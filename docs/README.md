# Dockerfile for HumHub Installation

This Dockerfile sets up a PHP 8.3.3 Apache environment and installs HumHub 1.15.3.

### Dockerfiles
| Operating Systems | Status |
|-------------------|--------|
| Linux             | [![Linux Dockerfile](https://github.com/GreenMeteor/humhub-docker/actions/workflows/test.yml/badge.svg)](https://github.com/GreenMeteor/humhub-docker/actions/workflows/test.yml) |
| MacOS             | TBA    |
| Windows           | TBA    |

### Instructions:

1. **Base Image**: Uses `php:8.3.3-apache` as the base image.

2. **Dependencies Installation**:
   - Installs necessary packages via `apt-get`.
   - Configures PHP extensions for `gd`, `mysqli`, `pdo`, `zip`, `intl`, `ldap`, `pgsql`, `apcu`, and more.

3. **Directory Creation**:
   - Creates the directory structure: `/var/www/html` for HumHub installation.

4. **HumHub Installation**:
   - Downloads HumHub version 1.15.3 using `curl`.
   - Unzips the downloaded file to `/tmp/humhub_folder`.
   - Copies HumHub contents to `/var/www/html`.
   - Adjusts ownership and permissions for `/var/www/html`.
   - Cleans up downloaded files and temporary folders.

5. **Exposing Ports**:
   - Exposes port `80` for HTTP traffic.

6. **Working Directory**:
   - Sets `/var/www/html` as the working directory.

7. **Starting Service**:
   - Initiates the Apache & Cron services using `apache2-foreground` & `service cron start`.

### Building the Image:

Build the Docker image using the provided Dockerfile:

```bash
docker build -t humhub-docker .
```
