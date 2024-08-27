FROM php:7.3-fpm-alpine

# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    curl-dev \
    imagemagick-dev \
    libtool \
    libxml2-dev \
    postgresql-dev \
    sqlite-dev \
    automake

# Install production dependencies
RUN apk add --no-cache \
    bash \
    curl \
    g++ \
    gcc \
    git \
    imagemagick \
    libc-dev \
    libpng-dev \
    make \
    mysql-client \
    openssh-client \
    postgresql-libs \
    rsync \
    zlib-dev \
    libzip-dev

# Install PECL and PEAR extensions
RUN pecl install \
    imagick

# Install and enable php extensions
RUN docker-php-ext-enable \
    imagick

RUN docker-php-ext-configure zip --with-libzip
RUN docker-php-ext-install \
    curl \
    mbstring \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pcntl \
    tokenizer \
    xml \
    gd \
    zip \
    bcmath \
    mysqli

# Add custom configuration
ARG CUSTOM_INI=/usr/local/etc/php/conf.d/custom.ini
RUN echo "upload_max_filesize = 64M" >> ${CUSTOM_INI}
RUN echo "memory_limit = 1024M" >> ${CUSTOM_INI}
RUN echo "max_execution_time = 300" >> ${CUSTOM_INI}


# Enable errors
RUN echo "error_log = \"/var/log/error.log\"" >> ${CUSTOM_INI}
RUN echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE" >> ${CUSTOM_INI}
RUN echo "display_errors = On" >> ${CUSTOM_INI}
RUN echo "display_startup_errors = On" >> ${CUSTOM_INI}

# Set workdir
WORKDIR /var/www/html

# Copy the source code to the container's /var/www/html directory
COPY ./src /var/www/html

# Use the Nginx latest image as the web server
# FROM nginx:latest
RUN apk add --no-cache nginx

# Copy the Nginx configuration file to the container's /etc/nginx/conf.d directory
COPY ./docker/nginx /etc/nginx
COPY ./docker/nginx/conf.d /etc/nginx/conf.d

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start both PHP-FPM and Nginx processes
CMD ["sh", "-c", "php-fpm & nginx -g 'daemon off;'"]
