# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Added `src/apache2.conf` file to set `ServerName localhost` in Apache configuration.
- Updated Dockerfile to include `ServerName localhost` in `apache2.conf` to suppress Apache warnings.
- Implemented cron service start in Dockerfile CMD to ensure cron starts with Apache.
- Added health check to Dockerfile to verify cron service status.

### Changed

- Modified Dockerfile CMD to start both cron and Apache in the foreground.

### Fixed

- Fixed GitHub Action workflow to properly verify cron service status after container start.
- Resolved issue with cron service verification in GitHub Action output.

## [1.15.6] - 2024-06-16

### Added

- v1.15.6 release of HumHub Docker image with basic setup.
