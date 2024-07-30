# Stage 1: Builder
FROM php:8.3.9-apache AS builder

# Install build dependencies and PHP extensions
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
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
        libgmp-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
        gd \
        exif \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        intl \
        ldap \
        opcache \
        pgsql \
        pdo_pgsql \
        mbstring \
        gmp

RUN pecl install imagick-3.7.0 apcu-5.1.23 && \
    docker-php-ext-enable imagick apcu && \
    a2enmod rewrite deflate && \
    rm -rf /tmp/* /var/tmp/*

# Download and install HumHub
WORKDIR /tmp
ARG HUMHUB_VERSION=1.16.1
RUN curl -L -o humhub.zip https://download.humhub.com/downloads/install/humhub-${HUMHUB_VERSION}.zip && \
    unzip humhub.zip -d /tmp/humhub_folder && \
    rm humhub.zip && \
    rm -rf /tmp/* /var/tmp/*

# Stage 2: Runtime Dependencies
FROM php:8.3.9-apache AS runtime-deps

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Stage 3: Final
FROM runtime-deps AS final

# Copy PHP extensions and configurations from builder
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d

# Configure Apache
RUN a2enmod rewrite deflate && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Create a non-root user
RUN groupadd -r humhub && useradd -r -g humhub humhub

# Copy HumHub from the builder stage
COPY --from=builder --chown=humhub:humhub /tmp/humhub_folder /var/www/html

# Copy custom Apache configuration files
COPY --chown=root:root src/apache2.conf /etc/apache2/apache2.conf
COPY --chown=root:root src/humhub.conf /etc/apache2/sites-available/humhub.conf

# Enable the custom configuration
RUN a2ensite humhub

# Set permissions
RUN find /var/www/html -type d -exec chmod 755 {} + && \
    find /var/www/html -type f -exec chmod 644 {} +

# Copy the cron file and set permissions
COPY --chown=root:root src/crontab /etc/cron.d/humhub-cron
RUN chmod 0644 /etc/cron.d/humhub-cron

# Expose ports
EXPOSE 80 443

# Define the working directory
WORKDIR /var/www/html

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Use a non-root user
USER humhub

# Start cron and Apache
CMD service cron start && apache2-foreground

# Metadata for provenance
LABEL org.opencontainers.image.source="https://github.com/GreenMeteor/humhub-docker"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.base.name="php:8.3.9-apache"
