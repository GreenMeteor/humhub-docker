# Dockerfile for HumHub Installation

[![Dockerfile Test](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml/badge.svg?event=push)](https://github.com/GreenMeteor/humhub-docker/actions/workflows/tests.yml)

This Dockerfile sets up a PHP environment with Apache and installs HumHub, a social network platform.

### Usage

To build the Docker image, ensure the HumHub zip file (`humhub-1.15.0.zip`) is present in the same directory as this Dockerfile.

```bash
docker build -t your_image_name --build-arg HUMHUB_FOLDER=custom_humhub_folder .
```

Replace `your_image_name` with your desired image name/tag. Adjust `HUMHUB_FOLDER` to specify the HumHub folder name during the build process.

### Details

#### Base Image
- **PHP Version**: 8.1
- **Apache**: Included in the PHP image

#### Environment Variables
- `HUMHUB_VERSION`: HumHub version to be installed (default: 1.15.0)
- `HUMHUB_URL`: URL to download HumHub zip file
- `HUMHUB_DIR`: Installation path for HumHub (default: /var/www/html)
- `HUMHUB_FOLDER`: Folder name to extract HumHub files during installation (default: humhub_folder)

#### Installation Steps
1. **Dependencies Installation**:
   - Updates and installs required packages using apt-get
   - Installs PHP extensions necessary for HumHub (GD, mysqli, pdo, pdo_mysql, zip, intl, ldap, pgsql, pdo_pgsql)
   - Enables Apache's rewrite module

2. **HumHub Installation**:
   - Downloads the HumHub zip file specified in `HUMHUB_URL`
   - Unzips the file into the folder specified in `HUMHUB_FOLDER`
   - Copies the contents of `HUMHUB_FOLDER` to the installation directory (`HUMHUB_DIR`)
   - Sets permissions and ownership for HumHub files
   - Removes temporary files after installation

#### Usage in a Docker Run Command
To start a container from the built image:

```bash
docker run -p 8080:80 your_image_name
```

This command maps port 8080 on your host machine to port 80 on the container.

Adjust the port mapping (`-p`) as needed.

### Notes
- Customize the `HUMHUB_FOLDER` variable during the build process to specify the folder name for HumHub.
- Ensure the HumHub zip file is present in the same directory when building the image.

### Notice
> No License Expected: This project is not licensed, which means no permissions are granted for modifications, distribution, or any use of the code. This repository is provided as-is, without warranty or support.
