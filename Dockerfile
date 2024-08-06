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
