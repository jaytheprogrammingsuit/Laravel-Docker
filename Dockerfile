FROM php:8.1 as php

# Install system dependencies
RUN apt-get update -y
RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql bcmath

# redis service
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# Set working directory
WORKDIR /var/www
COPY . .

# Install Composer
COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer

# Install Composer dependencies
RUN composer install

# Set environment variables
ENV PORT=8000

# Set the entrypoint
ENTRYPOINT [ "docker/entrypoint.sh" ]