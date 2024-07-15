FROM php:8.3.9-apache AS builder
# Use buildx cache mount for faster builds
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libexif-dev \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    libldap2-dev \
    libpq-dev \
    libonig-dev \
    libgmp-dev \
    libmagickwand-dev

# Install and enable PHP extensions
RUN --mount=type=cache,target=/tmp/pear \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    gd exif intl mysqli pdo_mysql zip opcache ldap gmp && \
    pecl install apcu-5.1.23 imagick && \
    docker-php-ext-enable apcu imagick

# Enable Apache modules
RUN a2enmod rewrite deflate

# Download and install HumHub
WORKDIR /tmp
ARG HUMHUB_VERSION=1.16.1
RUN --mount=type=cache,target=/tmp/humhub \
    curl -L -o humhub.zip https://download.humhub.com/downloads/install/humhub-${HUMHUB_VERSION}.zip && \
    unzip humhub.zip -d /tmp/humhub_folder && \
    rm humhub.zip

FROM php:8.3.9-apache AS runtime
# Copy PHP extensions and configurations from builder
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Install runtime dependencies
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    libpng16-16 \
    libjpeg62-turbo \
    libfreetype6 \
    libzip4 \
    libicu72 \
    libldap-2.5-0 \
    libpq5 \
    libgmp10 \
    libmagickwand-6.q16-6 \
    cron && \
    a2enmod rewrite deflate

# Create a non-root user
RUN groupadd -r humhub && useradd -r -g humhub humhub

# Copy HumHub from the builder stage
COPY --from=builder /tmp/humhub_folder /var/www/html

# Copy custom Apache configuration files
COPY src/apache2.conf /etc/apache2/apache2.conf
COPY src/humhub.conf /etc/apache2/sites-available/humhub.conf
RUN a2ensite humhub

# Set ownership and permissions
RUN chown -R humhub:humhub /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} + && \
    find /var/www/html -type f -exec chmod 644 {} +

# Copy the cron file and set permissions
COPY --chown=humhub:humhub src/crontab /etc/cron.d/humhub-cron
RUN chmod 0644 /etc/cron.d/humhub-cron

# Expose ports
EXPOSE 80 443

# Define the working directory
WORKDIR /var/www/html

# Healthcheck to monitor the status of the container
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl --fail http://localhost || exit 1

# Use tini as init system
RUN apt-get update && apt-get install -y tini && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start Apache service and cron in the foreground as non-root user
USER humhub
CMD ["sh", "-c", "service cron start && apache2-foreground"]
