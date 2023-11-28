# Dockerfile for HumHub Installation

[![Dockerfile Test](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml/badge.svg?event=push)](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml) [![Build and Push Docker Image on Release](https://github.com/GreenMeteor/humhub-docker/actions/workflows/published.yml/badge.svg?event=release)](https://github.com/GreenMeteor/humhub-docker/actions/workflows/published.yml)

This Dockerfile sets up a PHP 8.2 Apache environment and installs HumHub 1.15.0.

### Instructions:

1. **Base Image**: Uses `php:8.2-apache` as the base image.

2. **Dependencies Installation**:
    - Installs necessary packages via `apt-get`.
    - Configures PHP extensions for `gd`, `mysqli`, `pdo`, `zip`, `intl`, `ldap`, `pgsql`, and more.

3. **Directory Creation**:
    - Creates the directory structure: `/var/www/html` for HumHub installation.

4. **HumHub Installation**:
    - Downloads HumHub version 1.15.0 using `curl`.
    - Unzips the downloaded file to `/tmp/humhub_folder`.
    - Copies HumHub contents to `/var/www/html`.
    - Adjusts ownership and permissions for `/var/www/html`.
    - Cleans up downloaded files and temporary folders.

5. **Exposing Ports**:
    - Exposes port `80` for HTTP traffic.

6. **Working Directory**:
    - Sets `/var/www/html` as the working directory.

7. **Starting Service**:
    - Initiates the Apache service using `apache2-foreground`.

### Building the Image:

Build the Docker image using the provided Dockerfile:

```bash
docker build -t humhub-docker .
```
