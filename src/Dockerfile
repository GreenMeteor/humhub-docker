# Stage 1: Builder
FROM php:8.3.8-apache AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    libldap2-dev \
    libpq-dev \
    libonig-dev \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl ldap pgsql pdo_pgsql \
    && a2enmod rewrite \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install HumHub
WORKDIR /tmp
ARG HUMHUB_VERSION=1.15.6
RUN curl -L -o humhub.zip https://download.humhub.com/downloads/install/humhub-${HUMHUB_VERSION}.zip \
    && unzip humhub.zip -d /tmp/humhub_folder \
    && rm humhub.zip

# Stage 2: Runtime Dependencies
FROM php:8.3.8-apache AS runtime-deps

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    cron \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Stage 3: Final
FROM runtime-deps

# Copy HumHub from the builder stage
COPY --from=builder /tmp/humhub_folder/. /var/www/html

# Set ownership and permissions
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} + \
    && find /var/www/html -type f -exec chmod 644 {} +

# Copy the cron file and set permissions
COPY --chown=www-data:www-data src/crontab /etc/cron.d/humhub-cron
RUN chmod 0644 /etc/cron.d/humhub-cron

# Expose ports
EXPOSE 80

# Define the working directory
WORKDIR /var/www/html

# Healthcheck to monitor the status of the container
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl --fail http://localhost || exit 1

# Start Apache service and cron in the foreground
CMD ["sh", "-c", "cron && apache2-foreground"]
