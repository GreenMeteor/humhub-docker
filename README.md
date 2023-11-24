# HumHub Docker Setup
[![Dockerfile Test](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml/badge.svg?event=push)](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml)

This repository contains a Docker setup for running HumHub, an open-source social networking platform, along with MySQL, Redis, and SMTP mailer within Docker containers.

## Prerequisites

- Docker installed on your system ([Install Docker](https://docs.docker.com/get-docker/))

## Building the Docker Image

To build the HumHub Docker image, follow these steps:

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/humhub-docker.git
    cd humhub-docker
    ```

2. Update the `docker-compose.yml` file:
   - Set appropriate environment variables for HumHub, MySQL, SMTP mailer, and Redis.
   - Adjust ports if necessary.

3. Build the Docker image:

    ```bash
    docker build -t humhub-image .
    ```

## Starting the Containers

After building the Docker image, start the containers by running:

```bash
docker-compose up -d
```

### Notice
No License Expected: This project is not licensed, which means no permissions are granted for modifications, distribution, or any use of the code. This repository is provided as-is, without warranty or support.

> Note: Without a specified license, default copyright laws apply, allowing viewing of the code but not granting any permissions for usage, modification, or distribution. Any use of the code should be done in compliance with applicable laws.
