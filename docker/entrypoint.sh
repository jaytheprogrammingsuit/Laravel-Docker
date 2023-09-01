#!/bin/bash

# Check if Composer dependencies are installed
if [ ! -f "vendor/autoload.php" ]; then 
    echo "check point 1"
    # composer install --no-progress --no-interactive
    composer install --no-progress
    echo "check point 2"
fi

# Check if .env file exists
if [ ! -f ".env" ]; then 
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
else
    echo "env file already exists"
fi

php artisan migrate
php artisan key:generate
php artisan cache:clear
php artisan config:clear
php artisan route:clear

php artisan serve --port=$PORT --host=0.0.0.0 --env=.env
exec docker-php-entrypoint "$@"