## Changelogs

### `Dockerfile` Changes:

- **Multi-stage Build**: Implemented a multi-stage build to optimize the final image size and reduce unnecessary dependencies in the runtime stage.
- **System Dependencies**: Installed system dependencies using `apt-get install` with `--no-install-recommends` flag to minimize additional packages.

- **PHP and Apache Configuration**:
  - Configured PHP extensions (`gd`, `mysqli`, `pdo`, `pdo_mysql`, `zip`, `intl`, `ldap`, `pgsql`, `pdo_pgsql`) and enabled `apcu`.
  - Enabled Apache `rewrite` module (`a2enmod rewrite`).
  
- **HumHub Installation**: Downloaded and installed HumHub version 1.15.6 from the official source, optimizing the process by extracting directly into the `/tmp/humhub_folder` and cleaning up unnecessary files.
  
- **Final Stage**: Created a final stage to copy HumHub application files (`/tmp/humhub_folder`) into the `/var/www/html` directory of the runtime image.
  
- **Permissions**: Set ownership (`www-data:www-data`) and permissions (`755` for directories, `644` for files) for `/var/www/html` to ensure proper execution and security.
  
- **Cron Job**: Copied and set permissions for the cron job file (`src/crontab`) to `/etc/cron.d/humhub-cron`.

### `docker-compose.yml` Changes:

- **Removed MySQL Service**: The MySQL service configuration was removed from `docker-compose.yml` for simplicity. Ensure MySQL service is provided separately or as needed.

- **Nginx and Certbot Services**: Added Nginx and Certbot services for SSL termination and certificate management.

- **Volumes**: Configured volumes (`humhub_files`, `humhub_db_data`, `nginx_cert`) for persisting HumHub files, MySQL data, and SSL certificates.

- **Networking**: Defined a custom network (`humhub_network`) to facilitate communication between services.

- **SSL Configuration**: Integrated Nginx with Certbot for automatic SSL certificate management using Let's Encrypt.

### `mysql-compose.yml`:

- Added MySQL service configuration in a separate file (`mysql-compose.yml`) to manage MySQL database for HumHub.

> **Notes**:
> - Ensure MySQL service is provisioned separately or adjust the `docker-compose.yml` as needed to include MySQL service configuration.
> - Verify and update domain names (`your-domain.com`) and paths (`/var/www/html`, `/etc/letsencrypt/live/your-domain.com`) as per your actual setup.
