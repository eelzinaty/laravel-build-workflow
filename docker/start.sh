#!/bin/sh

# Optimize Laravel
echo "Running Laravel optimizations..."
php artisan optimize:clear
php artisan migrate --force
php artisan event:cache
php artisan config:cache
php artisan view:cache

# Start PHP-FPM in the background
echo "Starting PHP-FPM..."
php-fpm &

# Start Nginx in the foreground
echo "Starting Nginx..."
nginx -g "daemon off;"
