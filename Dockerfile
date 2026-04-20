FROM composer:2 AS composer-bin

FROM php:8.4-cli-alpine AS php-ext-builder

# Instala únicamente lo necesario para compilar extensiones.
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        freetype-dev \
        linux-headers \
        libzip-dev \
    ; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" \
        bcmath \
        exif \
        gd \
        intl \
        opcache \
        pdo \
        pdo_mysql \
        sockets \
        zip \
    ; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    rm -rf /tmp/pear ~/.pearrc

# Usa Alpine también en runtime para reducir tamaño real.
FROM php:8.4-cli-alpine

LABEL vendor="Symfony"
LABEL maintainer="Francisco Piedras <francisco@lonuncavisto.com>"

ENV APP_ENV=test \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_CACHE_DIR=/tmp/composer-cache

WORKDIR /var/www/html

# Instala solo dependencias de runtime y Symfony CLI.
RUN set -eux; \
    apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        git \
        icu-libs \
        libjpeg-turbo \
        libpng \
        freetype \
        libzip \
        mariadb-client \
        unzip \
    ; \
    curl -fsSL https://get.symfony.com/cli/installer | bash; \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony; \
    rm -rf /root/.symfony*

COPY --from=composer-bin /usr/bin/composer /usr/local/bin/composer
COPY --from=php-ext-builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=php-ext-builder /usr/local/etc/php/conf.d/docker-php-ext-* /usr/local/etc/php/conf.d/

RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/ci-memory.ini \
    && echo "default_socket_timeout = 60" > /usr/local/etc/php/conf.d/ci-timeout.ini \
    && echo "mysql.connect_timeout = 60" > /usr/local/etc/php/conf.d/ci-mysql.ini \
    && echo "xdebug.mode = coverage" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/xdebug.ini

CMD ["php", "-v"]
