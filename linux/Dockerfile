# Set default PHP version
FROM php:8.3.1-apache

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
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl ldap pgsql pdo_pgsql \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Create directory structure
RUN mkdir -p /var/www/html

# Download and install HumHub
WORKDIR /tmp
RUN curl -L -o humhub.zip https://download.humhub.com/downloads/install/humhub-1.15.2.zip \
    && unzip humhub.zip -d /tmp/humhub_folder \
    && cp -R /tmp/humhub_folder/. /var/www/html \
    && rm humhub.zip && rm -rf /tmp/humhub_folder

# Set ownership and permissions
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} + \
    && find /var/www/html -type f -exec chmod 644 {} +

# Copy the cron file
COPY --chown=root:root crontab /etc/cron.d/humhub-cron
RUN chmod 0644 /etc/cron.d/humhub-cron

# Load the cron file
RUN crontab /etc/cron.d/humhub-cron

# Expose ports
EXPOSE 80

# Define the working directory
WORKDIR /var/www/html

# Start Apache service and cron in the foreground
CMD ["sh", "-c", "service cron start && apache2-foreground"]
