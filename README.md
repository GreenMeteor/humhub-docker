# HumHub Docker Setup
[![Dockerfile Test](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml/badge.svg?event=push)](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml)

This repository contains a Docker setup for running HumHub, an open-source social networking platform, along with MySQL, Redis, and SMTP mailer within Docker containers.

## Prerequisites

- Docker installed on your system ([Install Docker](https://docs.docker.com/get-docker/))

## Getting Started

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/humhub-docker.git
    cd humhub-docker
    ```

2. Update the `docker-compose.yml` file:
   - Set appropriate environment variables for HumHub, MySQL, SMTP mailer, and Redis.
   - Adjust ports if necessary.

3. Start the containers:

    ```bash
    docker-compose up -d
    ```

4. Access HumHub in your web browser at `http://localhost:8080`.

## Configuration

### Environment Variables

The `docker-compose.yml` file uses environment variables to configure the services. Adjust these variables according to your preferences or environment setup.

- `MYSQL_HOST`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`: MySQL database configuration for HumHub.
- `HUMHUB_DIRECTORY`: Directory where HumHub is installed.
- `SMTP_HOST`, `SMTP_PORT`: SMTP mailer configuration.
- `REDIS_HOST`: Redis host for HumHub caching.

## Services

### HumHub
- Access HumHub: [http://localhost:8080](http://localhost:8080)
- Data volume: `humhub_data`

### MySQL
- MySQL version: 5.7
- Data volume: `humhub_db_data`

### Redis
- Redis version: Latest

## Additional Notes

- **SMTP Configuration**: Use `host.docker.internal` as the SMTP host to utilize the system mailer of the host machine.

- **Customization**: Refer to the HumHub documentation for advanced configurations and customization options.

- **Development/Testing**: For development or testing purposes, MailHog and other services can be substituted for the system mailer or Redis.

## Notice

**No License Expected**: This project is not licensed, which means no permissions are granted for modifications, distribution, or any use of the code. This repository is provided as-is, without warranty or support.

> **Note:** Without a specified license, default copyright laws apply, allowing viewing of the code but not granting any permissions for usage, modification, or distribution. Any use of the code should be done in compliance with applicable laws.

