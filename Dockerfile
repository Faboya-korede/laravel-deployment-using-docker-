FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG korede
ARG 1001

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1001 -d /home/korede korede
RUN mkdir -p /home/korede/.composer && \
    chown -R korede:korede /home/korede

# Set working directory
WORKDIR /var/www

USER korede
EXPOSE 9000

CMD ["php-fpm"]
