# Dockerfile Documentation

## Overview

This Dockerfile sets up a PHP 8.1 environment with Apache and installs HumHub, a social network platform. It includes necessary dependencies and configurations to run HumHub within an Apache server.

## Usage

### Building the Docker Image

To build the Docker image, execute the following command in the terminal:

```bash
docker build -t <image_name>:<tag> /path/to/Dockerfile
```

Replace `<image_name>` with the desired name for your image and `<tag>` with a version or tag you want to assign.

### Running the Docker Container

After building the image, run a container using:

```bash
docker run -d -p <host_port>:80 -e SUBDIR_PATH=<subdirectory> <image_name>:<tag>
```

Replace `<host_port>` with the port on your host machine. `<subdirectory>` is an optional environment variable to create a subdirectory within the container's `$HUMHUB_DIR`. `<image_name>` and `<tag>` should match the image and tag used during the build process.

### Environment Variables

This Dockerfile uses the following environment variables:

- `SUBDIR_PATH`: (Optional) Specifies a subdirectory path within `$HUMHUB_DIR`.

## Important Notes

- The exposed port is 80 by default. Ensure this port is available on your host or modify the `-p` flag in the `docker run` command to map to an available port.
- Modify the `HUMHUB_VERSION` environment variable to install a different version of HumHub if required.
- The installation path defaults to `/var/www/html`, but you can change it by setting the `INSTALL_PATH` argument during the build process.

## Example

```Dockerfile
# Use a base image with PHP 8.1 and Apache
FROM php:8.1-apache

# Arguments for customizable installation path
ARG INSTALL_PATH=/var/www/html

# Set environment variables
ENV HUMHUB_VERSION=1.15.0 \
    HUMHUB_URL=https://download.humhub.com/downloads/install/humhub-$HUMHUB_VERSION.zip \
    HUMHUB_DIR=$INSTALL_PATH

# ... (Rest of your Dockerfile content)

# Start Apache service
CMD ["apache2-foreground"]
```

## Dependencies

This Dockerfile installs various PHP extensions and system libraries required by HumHub, including:
- `curl`
- `unzip`
- `libpng-dev`
- `libjpeg-dev`
- `libfreetype6-dev`
- `libzip-dev`
- `zlib1g-dev`
- `libicu-dev`
- `libldap2-dev`
- `libpq-dev`
