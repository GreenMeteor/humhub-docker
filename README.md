# HumHub Docker Setup

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
**No License Expected**: This repository is provided without a specified license. You may use, modify, or distribute the code solely for personal or internal purposes. No license is granted for any commercial use or redistribution of this code.
