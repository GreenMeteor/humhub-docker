# Use a base image with PHP 8.1 and Apache
FROM php:8.1-apache

# Set environment variables
ENV HUMHUB_VERSION=1.15.0 \
    HUMHUB_URL=https://www.humhub.com/download/package/humhub-$HUMHUB_VERSION.tar.gz \
    HUMHUB_DIR=/var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Download and install HumHub
WORKDIR /tmp
RUN curl -L -o humhub.tar.gz $HUMHUB_URL \
    && tar -xzf humhub.tar.gz \
    && mv humhub-$HUMHUB_VERSION/* $HUMHUB_DIR \
    && chown -R www-data:www-data $HUMHUB_DIR \
    && chmod -R 755 $HUMHUB_DIR \
    && rm humhub.tar.gz \
    && rm -rf /tmp/*

# Expose ports
EXPOSE 80

# Define the working directory
WORKDIR $HUMHUB_DIR

# Start Apache service
CMD ["apache2-foreground"]
