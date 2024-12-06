# Stage 1: Build PHP environment (dependencies)
FROM php:8.3.3-slim AS builder

RUN apt-get update && apt-get install -y \
  libpng-dev \
  libjpeg-dev \
  zip \
  php-mysqli  
  # Install MySQL driver for PHP

COPY composer.json .
RUN composer install --no-dev --prefer-dist

# Stage 2: Final image with minimal PHP runtime and application code
FROM php:8.3.3-fpm

# Copy dependencies
COPY --from=builder /vendor /app/vendor 
COPY . /app

# Expose port for PHP-FPM
EXPOSE 9000  

CMD ["php-fpm", "-F", "-c", "/etc/php/8.3.3/fpm/php.ini"]

# Stage 3: MySQL environment (separate container)
FROM mysql:8.0

ENV MYSQL_DATABASE blog-database

CMD ["mysqld"]