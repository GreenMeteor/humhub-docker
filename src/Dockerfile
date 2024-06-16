# Use a multi-stage build to reduce final image size
FROM php:8.3.8-apache AS builder

# Install system dependencies
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
    cron \
    libonig-dev \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl ldap pgsql pdo_pgsql \
    && a2enmod rewrite \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install HumHub
WORKDIR /tmp
RUN curl -L -o humhub.zip https://download.humhub.com/downloads/install/humhub-1.15.6.zip \
    && unzip humhub.zip -d /tmp/humhub_folder \
    && rm humhub.zip

# Final stage: copy built application
FROM php:8.3.7-apache

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    cron \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

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

# Start Apache service and cron in the foreground
CMD ["sh", "-c", "service cron start && apache2-foreground"]
