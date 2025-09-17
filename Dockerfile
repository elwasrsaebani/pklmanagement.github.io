# Gunakan PHP 8.2 dengan Apache
FROM php:8.2-apache

# Install extension yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy semua file Laravel ke container
COPY . .

# Install dependency Laravel
RUN composer install --no-dev --optimize-autoloader

# Set permission untuk storage & bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache

# Laravel public folder jadi document root
WORKDIR /var/www/html/public

# Expose port 80
EXPOSE 80

# Jalankan Apache
CMD ["apache2-foreground"]
