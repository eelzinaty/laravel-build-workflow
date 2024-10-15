# 1. Base Image with PHP-FPM
FROM php:8.3-fpm-alpine AS base

# Install necessary packages and PHP extensions
RUN apk add --no-cache \
    nginx \
    dcron \
    libzip \
    icu \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    icu-dev \
    libzip-dev \
    # Configure and install PHP extensions
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
    pdo_mysql \
    intl \
    pcntl \
    opcache \
    zip \
    # Install Redis extension
    && pecl install redis \
    # Enable all installed extensions
    && docker-php-ext-enable \
    pdo_mysql \
    intl \
    pcntl \
    opcache \
    zip \
    redis \
    # Remove build dependencies
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

# 2. Composer Dependencies
FROM composer:2.7.7 AS deps
ARG APP_HOME=/var/www/html
WORKDIR $APP_HOME

# Copy only composer files
COPY composer.json composer.lock $APP_HOME/

# Install composer dependencies
RUN composer install --prefer-dist --no-scripts --no-progress --no-interaction --optimize-autoloader --no-dev --ignore-platform-req=ext-gd

# 3. Build Assets with Node.js
FROM node:20-alpine AS build-assets
ARG APP_HOME=/var/www/html
WORKDIR $APP_HOME

# Copy only package files and install npm
COPY package.json $APP_HOME/
RUN npm install

# Copy the rest of the application code necessary for building assets
COPY resources/ $APP_HOME/resources/
COPY public/ $APP_HOME/public/
COPY vite.config.js $APP_HOME/
RUN npm run build

# 4. Final Application Image
FROM base
ARG APP_HOME=/var/www/html
ENV APP_HOME=$APP_HOME

# Create application directory
RUN rm -rf $APP_HOME && mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Copy Nginx configuration files with proper ownership
COPY --chown=www-data:www-data ./docker/nginx.conf /etc/nginx/nginx.conf
COPY --chown=www-data:www-data ./docker/site.conf /etc/nginx/conf.d/default.conf

# Copy PHP configuration with proper ownership
COPY --chown=www-data:www-data ./docker/php.ini /usr/local/etc/php/php.ini

# Copy start scripts with proper ownership
COPY --chown=www-data:www-data ./docker/start.sh /

# Set permissions and ownership
RUN \
    # Ensure /var/www/html has the correct ownership and permissions
    chown -R www-data:www-data $APP_HOME && \
    chmod -R 755 $APP_HOME && \
    \
    # Ensure /var/cache/nginx/ exists with correct ownership
    mkdir -p /var/cache/nginx/ && \
    chown -R www-data:www-data /var/cache/nginx/ && \
    \
    # Ensure Nginx directories have correct ownership
    chown -R www-data:www-data /etc/nginx/ && \
    chown -R www-data:www-data /var/log/nginx && \
    \
    # Ensure start scripts are executable
    chmod +x /start.sh

# Expose port 80 for Nginx
EXPOSE 80

# Copy composer dependencies with proper ownership
COPY --from=deps --chown=www-data:www-data $APP_HOME/vendor $APP_HOME/vendor

# Copy built assets with proper ownership
COPY --from=build-assets --chown=www-data:www-data $APP_HOME/public $APP_HOME/public

# Copy the rest of the application code with proper ownership
COPY --chown=www-data:www-data . $APP_HOME

# Define the default command
CMD ["/start.sh"]
