# Stage 1: Builder
FROM php:8.3.11-apache AS builder

# Install build dependencies
RUN apt-get update --no-install-recommends && \
    apt-get install -y --no-install-recommends \
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
    libonig-dev && \
    pecl install apcu-5.1.23 && \
    docker-php-ext-enable apcu && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl ldap pgsql pdo_pgsql mbstring exif

# Clean up APT cache and remove temporary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install HumHub
WORKDIR /tmp
ARG HUMHUB_VERSION=1.16.2
RUN curl -L -o humhub.zip https://download.humhub.com/downloads/install/humhub-${HUMHUB_VERSION}.zip && \
    unzip humhub.zip -d /tmp/humhub_folder && \
    rm humhub.zip

# Stage 2: Runtime Dependencies
FROM php:8.3.11-apache AS runtime-deps

# Install runtime dependencies
RUN apt-get update --no-install-recommends && \
    apt-get install -y --no-install-recommends cron

# Clean up APT cache and remove temporary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Stage 3: Final
FROM runtime-deps AS final

# Metadata for provenance
LABEL org.opencontainers.image.source="https://github.com/GreenMeteor/humhub-docker"
LABEL org.opencontainers.image.revision="$GIT_COMMIT"
LABEL org.opencontainers.image.base.name="php:8.3.11-apache"

# Create a non-root user
RUN groupadd -r humhub && useradd -r -g humhub humhub

# Copy HumHub from the builder stage
COPY --from=builder /tmp/humhub_folder/. /var/www/html

# Copy custom Apache configuration files
COPY src/apache2.conf /etc/apache2/apache2.conf
COPY src/humhub.conf /etc/apache2/sites-available/humhub.conf

# Explicitly install and enable MPM module
RUN apt-get update --no-install-recommends && \
    apt-get install -y apache2 && \
    a2dismod mpm_event mpm_worker && \
    a2enmod mpm_prefork

# Clean up APT cache and remove temporary files
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable the custom configuration
RUN a2ensite humhub

# Set ownership and permissions
RUN chown -R humhub:humhub /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} + && \
    find /var/www/html -type f -exec chmod 644 {} +

# Copy the cron file and set permissions
COPY --chown=root:root src/crontab /etc/cron.d/humhub-cron
RUN chmod 0644 /etc/cron.d/humhub-cron

# Expose ports
EXPOSE 80
EXPOSE 443

# Define the working directory
WORKDIR /var/www/html

# Healthcheck to monitor the status of the container
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl --fail http://localhost || exit 1

# Create a startup script
RUN printf '#!/bin/bash\n\
service cron start\n\
apache2-foreground' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Start Apache service and cron
CMD ["/usr/local/bin/startup.sh"]
