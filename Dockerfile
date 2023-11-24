# Use a base image with PHP 8.1 and Apache
FROM php:8.1-apache

# Arguments for customizable installation path
ARG INSTALL_PATH=/var/www/html

# Set environment variables
ENV HUMHUB_VERSION=1.15.0 \
    HUMHUB_URL=https://download.humhub.com/downloads/install/humhub-$HUMHUB_VERSION.zip \
    HUMHUB_DIR=$INSTALL_PATH

# Install dependencies
RUN apt-get update && apt-get install -y \
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
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl ldap pgsql pdo_pgsql \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Create subdirectory structure if passed as an argument
ARG SUBDIR_PATH
RUN if [ -n "$SUBDIR_PATH" ]; then mkdir -p $HUMHUB_DIR/$SUBDIR_PATH; fi

# Download and install HumHub
WORKDIR /tmp
RUN curl -L -o humhub.zip $HUMHUB_URL \
    && unzip humhub.zip -d humhub_folder \
    && ls -la humhub_folder \
    && cp -R humhub_folder/. $HUMHUB_DIR/$SUBDIR_PATH \
    && ls -la $HUMHUB_DIR/$SUBDIR_PATH \
    && chown -R www-data:www-data $HUMHUB_DIR \
    && chmod -R 755 $HUMHUB_DIR

# Expose ports
EXPOSE 80

# Define the working directory
WORKDIR $HUMHUB_DIR/$SUBDIR_PATH

# Start Apache service
CMD ["apache2-foreground"]
