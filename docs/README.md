# Dockerfile for HumHub Installation

This Dockerfile sets up a PHP 8.3.8 Apache environment and installs HumHub 1.16.1.

### Dockerfiles
| Operating Systems | Status |
|-------------------|--------|
| Linux             | [![Docker](https://github.com/GreenMeteor/humhub-docker/actions/workflows/docker.yml/badge.svg?branch=main&event=push)](https://github.com/GreenMeteor/humhub-docker/actions/workflows/docker.yml) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/b2581f3610ad4c418d44e8c325ca7f28)](https://app.codacy.com/gh/GreenMeteor/humhub-docker/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade) |
| MacOS             | TBA    |
| Windows           | TBA    |

### Instructions:

1. **Base Image**: Uses `php:8.3.8-apache` as the base image.

2. **Dependencies Installation**:
   - Installs necessary packages via `apt-get`.
   - Configures PHP extensions for `gd`, `mysqli`, `pdo`, `zip`, `intl`, `ldap`, `pgsql`, `mbstring`, `exif`, `imagick`, `apcu`, and more.

3. **HumHub Installation**:
   - Downloads HumHub version 1.16.1 using `curl`.
   - Unzips the downloaded file to `/tmp/humhub_folder`.
   - Copies HumHub contents to `/var/www/html`.
   - Adjusts ownership and permissions for `/var/www/html`.
   - Cleans up downloaded files and temporary folders.

4. **Custom Apache Configuration**:
   - Copies custom Apache configuration files to the appropriate locations.
   - Enables the custom configuration.

5. **Exposing Ports**:
   - Exposes ports `80` and `443` for HTTP and HTTPS traffic.

6. **Working Directory**:
   - Sets `/var/www/html` as the working directory.

7. **Healthcheck**:
   - Includes a healthcheck to monitor the status of the container.

8. **Starting Service**:
   - Initiates the Apache & Cron services using `apache2-foreground` & `service cron start`.

### Building the Image:

Build the Docker image using the provided Dockerfile:

```bash
docker build -t humhub-docker .
```

If you enjoy our work please consider [donating](https://donate.stripe.com/00g7uJ4gb7UZePu8wM).
