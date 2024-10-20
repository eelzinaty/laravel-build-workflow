
# Accelerating Docker Image Builds by 90% Using GitHub Actions Cache

This repository demonstrates how to enhance developer experience by significantly reducing Docker image build times—up to **90% faster**—using GitHub Actions Cache and applying Docker best practices. The sample project is a PHP Laravel 11 application configured with optimised workflows and Docker setups.

This repository complements the article [Enhancing Developer Experience: Accelerating Docker Image Builds by 90% Using GitHub Actions Cache](#), providing practical examples of the concepts discussed.


## Table of Contents

- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Workflows Explained](#workflows-explained)
  - [1. build_publish.yaml](#1-build_publishyaml)
  - [2. cleanup_cache.yaml](#2-cleanup_cacheyaml)
  - [3. scheduled_workflow.yaml](#3-scheduled_workflowyaml)
- [Docker Setup Explained](#docker-setup-explained)
  - [Dockerfile](#dockerfile)
  - [Configuration Files](#configuration-files)
    - [nginx.conf](#nginxconf)
    - [site.conf](#siteconf)
    - [php.ini](#phpini)
    - [start.sh](#startsh)
- [Optimisations Applied](#optimisations-applied)
  - [.dockerignore](#dockerignore)

## Project Structure

```
├── .github/
│   └── workflows/
│       ├── build_publish.yaml
│       ├── cleanup_cache.yaml
│       └── scheduled_workflow.yaml
├── docker/
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── php.ini
│   ├── site.conf
│   └── start.sh
├── .dockerignore
├── app/            # Laravel application code
├── bootstrap/
├── config/
├── public/
└── ...             # Other Laravel directories and files
```

## Getting Started

To explore how the build optimisations work:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/eelzinaty/laravel-build-workflow.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd laravel-build-workflow
   ```

3. **Examine the workflows and Docker setup as explained below.**

## Workflows Explained

The GitHub Actions workflows are located in `.github/workflows/`. There are three workflows configured to manage the build and caching process effectively.

### 1. `build_publish.yaml`

**Purpose:** Builds the Docker image when changes are pushed to the `main` branch or when a new pull request is opened against `main`. It leverages caching to speed up the build process.

**Key Features:**

- **Caching Docker Layers:**
  Utilises GitHub Actions Cache to store Docker layers and speeds up subsequent builds.

- **Build Docker Image:**
  Uses `docker/build-push-action` with caching options to build the Docker image efficiently.

- **Cache Management:**
  Updates the cache with new image layers after the build.

**Trigger Conditions:**

- On push to the `main` branch.
- On opening a new pull request against `main`.

### 2. `cleanup_cache.yaml`

**Purpose:** Cleans up unused caches to manage storage limitations of GitHub Actions Cache. This workflow is triggered when a pull request is closed.

**Key Features:**

- **Automatic Cache Deletion:**
  Deletes caches associated with pull requests that have been closed.

- **Storage Optimisation:**
  Helps in staying within the 10 GB cache limit by removing unnecessary data.

### 3. `scheduled_workflow.yaml`
**Purpose:** Performs a scheduled build to refresh the cache with the latest code from the `main` branch.

**Note:** You don't need this step if you already build and publish after PR merge, as explained in the current workflow.

**Key Features:**

- **Nightly Builds:**
  Runs daily at midnight to keep the cache warm.

- **Cache Availability:**
  Ensures that new pull requests can leverage the most recent cache from `main`, speeding up their initial builds.

## Docker Setup Explained

The Docker configuration files are located in the `docker/` directory. They are set up to create an efficient and optimised Docker image for the Laravel application.

### Dockerfile

A multi-stage Dockerfile designed with four stages to optimise build times and image size.

**Stages:**

1. **Base Stage:**

   - **Image:** `php:8.3-fpm-alpine`
   - **Purpose:** Sets up the base environment by installing system packages and PHP extensions required for the application.

2. **Composer Dependencies Stage:**

   - **Image:** `composer:2.7.7`
   - **Purpose:** Installs PHP Composer dependencies.

3. **Node Dependencies Stage:**

   - **Image:** `node:20-alpine`
   - **Purpose:** Installs Node.js dependencies for the frontend assets.

4. **Final Stage:**

   - **Image:** Uses the `base` stage.
   - **Purpose:** Combines all dependencies and application code, and sets up the `CMD`.

### Configuration Files

#### nginx.conf

Configures Nginx with optimal settings for serving the Laravel application.

#### site.conf

Defines the server block for Nginx.

#### php.ini

Custom PHP settings for the application.

#### start.sh

An entrypoint script to start PHP-FPM and Nginx services.

## Optimisations Applied

### .dockerignore

Located at the root of the project, the `.dockerignore` file excludes unnecessary files from the Docker build context.

**Entries:**

```
*.md
tests/
.git/
vendor/
node_modules/
.env
```

**Benefits:**

- **Reduced Build Context Size:**
  Speeds up the Docker build process by sending fewer files.

- **Improved Cache Efficiency:**
  Prevents changes in ignored files from invalidating Docker cache layers.

---

By exploring this repository, you can see practical implementations of the techniques discussed in the article [Enhancing Developer Experience: Accelerating Docker Image Builds by 90% Using GitHub Actions Cache](#). Feel free to use this as a reference for optimising your own projects.

**Happy coding!**
