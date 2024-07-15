# Stage 1: Builder
FROM php:8.3.9-apache AS builder

# Install build system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && rm -rf /var/lib/apt/lists/*

# Install and enable PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    ctype \
    curl \
    dom \
    exif \
    fileinfo \
    gd \
    iconv \
    intl \
    json \
    libxml \
    mbstring \
    mysqli \
    pdo \
    pdo_mysql \
    zip \
    opcache

# Install APCu
RUN pecl install apcu-5.1.23 && docker-php-ext-enable apcu

# Enable Apache modules
RUN a2enmod rewrite deflate

# Download and install HumHub
WORKDIR /tmp
ARG HUMHUB_VERSION=1.16.1
RUN curl -L -o humhub.zip https://download.humhub.com/downloads/install/humhub-${HUMHUB_VERSION}.zip \
    && unzip humhub.zip -d /tmp/humhub_folder \
    && rm humhub.zip

# Stage 2: Runtime
FROM php:8.3.9-apache

# Copy PHP extensions and configurations from builder
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng16-16 \
    libjpeg62-turbo \
    libfreetype6 \
    libzip4 \
    libicu72 \
    libldap-2.5-0 \
    libpq5 \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite deflate

# Create a non-root user
RUN groupadd -r humhub && useradd -r -g humhub humhub

# Copy HumHub from the builder stage
COPY --from=builder /tmp/humhub_folder /var/www/html

# Copy custom Apache configuration files
COPY src/apache2.conf /etc/apache2/apache2.conf
COPY src/humhub.conf /etc/apache2/sites-available/humhub.conf

# Enable the custom configuration
RUN a2ensite humhub

# Set ownership and permissions
RUN chown -R humhub:humhub /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} + && \
    find /var/www/html -type f -exec chmod 644 {} +

# Copy the cron file and set permissions
COPY --chown=humhub:humhub src/crontab /etc/cron.d/humhub-cron
RUN chmod 0644 /etc/cron.d/humhub-cron

# Expose ports
EXPOSE 80
EXPOSE 443

# Define the working directory
WORKDIR /var/www/html

# Healthcheck to monitor the status of the container
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl --fail http://localhost || exit 1

# Start Apache service and cron in the foreground as non-root user
USER humhub
CMD ["sh", "-c", "service cron start && apache2-foreground"]
