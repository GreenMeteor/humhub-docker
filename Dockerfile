# Set default PHP version
ARG PHP_VERSION=8.1

# Use a base image with the specified PHP version and Apache
FROM php:${PHP_VERSION}-apache

# Arguments for customizable installation path
ARG INSTALL_PATH=/var/www/html
ENV HUMHUB_VERSION=1.15.0 \
    HUMHUB_URL=https://download.humhub.com/downloads/install/humhub-$HUMHUB_VERSION.zip \
    HUMHUB_DIR=$INSTALL_PATH \
    HUMHUB_FOLDER=humhub_folder

# Install dependencies
RUN set -eux; \
    apt-get update && apt-get install -y \
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
RUN if [ -n "$SUBDIR_PATH" ]; then \
    mkdir -p "$HUMHUB_DIR/$SUBDIR_PATH"; \
    fi

# Download and install HumHub
WORKDIR /tmp
RUN curl -L -o humhub.zip $HUMHUB_URL \
    && unzip humhub.zip -d "$HUMHUB_FOLDER" \
    && cp -R "$HUMHUB_FOLDER"/. "$HUMHUB_DIR/$SUBDIR_PATH" \
    && chown -R www-data:www-data "$HUMHUB_DIR" \
    && chmod -R 755 "$HUMHUB_DIR" \
    && rm humhub.zip && rm -rf "$HUMHUB_FOLDER"

# Expose ports
EXPOSE 80

# Define the working directory
WORKDIR "$HUMHUB_DIR/$SUBDIR_PATH"

# Start Apache service
CMD ["apache2-foreground"]
