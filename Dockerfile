# Usa la imagen base de PHP con CLI (mejor para CI)
FROM php:8.4-cli

LABEL vendor="Symfony"
LABEL maintainer="Francisco Piedras <francisco@lonuncavisto.com>"

# Instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    mariadb-client \
    libpq-dev \
    libcurl4-gnutls-dev \
    libicu-dev \
    libvpx-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libxml2-dev \
    libexpat1-dev \
    libbz2-dev \
    libgmp3-dev \
    libldap2-dev \
    unixodbc-dev \
    libsqlite3-dev \
    libaspell-dev \
    libsnmp-dev \
    libtidy-dev \
    libonig-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Configura e instala extensiones PHP necesarias
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        intl \
        pdo \
        pdo_mysql \
        zip \
        gd \
        opcache \
        bcmath \
        sockets \
        exif

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala Xdebug con configuración específica para CI
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Configuración de PHP para CI/Testing
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/ci-memory.ini \
    && echo "default_socket_timeout = 60" > /usr/local/etc/php/conf.d/ci-timeout.ini \
    && echo "mysql.connect_timeout = 60" > /usr/local/etc/php/conf.d/ci-mysql.ini

# Configuración de Xdebug para coverage
RUN echo "xdebug.mode = coverage" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/xdebug.ini

# Instala Symfony CLI
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
    && apt-get update \
    && apt-get install -y symfony-cli \
    && rm -rf /var/lib/apt/lists/*

# Configuración de entorno
ENV APP_ENV=test
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_CACHE_DIR=/tmp/composer-cache

# Define el directorio de trabajo
WORKDIR /var/www/html

# Para CI no necesitamos Apache, solo CLI
CMD ["php", "-v"]
