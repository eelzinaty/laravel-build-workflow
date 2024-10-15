
# Laravel PHP with Nginx Dockerization & GitHub Actions CI

## Overview

This repository demonstrates how to efficiently dockerize a PHP Laravel application using Nginx and leverage GitHub Actions for continuous integration (CI). The CI workflow is designed to build, cache, and push Docker images to the GitHub Container Registry (ghcr.io), ensuring efficient builds by caching layers.

## Key Features

- **Dockerized PHP & Nginx Setup**: A complete Docker setup for running a Laravel PHP application with Nginx.
- **Composer & Node.js Asset Builds**: Use multi-stage builds to install PHP dependencies (via Composer) and compile frontend assets (via Node.js).
- **Efficient Caching**: The Docker workflow employs caching techniques to reduce build times by reusing previous layers whenever possible.
- **GitHub Actions Integration**: A CI pipeline that automates the build, caching, and push of Docker images to GitHub Container Registry.
- **PHP Extensions & Configurations**: Includes required PHP extensions, and a customizable `php.ini` configuration file.
- **Nginx Configuration**: Custom Nginx configuration optimized for Laravel applications.

## Setup

1. **Clone the repository**:

    ```bash
    git clone https://github.com/eelzinaty/laravel-build-workflow.git
    cd laravel-build-workflow
    ```

2. **Build and run the Docker container locally**:

    ```bash
    docker build -f ./docker/Dockerfile -t laravel-build-workflow .
    docker run --rm -p 8080:80 laravel-build-workflow
    ```

    Access the application at `http://localhost:8080`.

3. **GitHub Actions Workflow**:
    - The GitHub Actions workflow automatically builds, caches, and pushes Docker images when a pull request is opened or synchronized with the `main` branch.
    - Caching is implemented to speed up builds and optimize the continuous integration process.

## CI Workflow Highlights

- **Caching Docker Layers**: Uses GitHub Actions caching to speed up Docker builds by reusing layers for Composer dependencies, Node.js assets, and PHP extensions.
- **Automated Docker Image Publishing**: Builds and pushes images to the GitHub Container Registry (ghcr.io) tagged with the commit SHA.
