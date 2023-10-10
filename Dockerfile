# Usa la imagen base de PHP con Apache
FROM php:8.2-apache

LABEL vendor="Symfony"
LABEL maintainer="Francisco Piedras <francisco@lonuncavisto.com>"

# Instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
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
    libpcre3-dev \
    libtidy-dev \
    libonig-dev \
    libzip-dev

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Instala Symfony CLI
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash && apt install symfony-cli

# Configuración adicional de PHP si es necesario
RUN docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd imap intl mbstring mysqli pdo_mysql zip opcache bcmath sockets exif \
    && docker-php-ext-enable imap intl mbstring mcrypt mysqli pdo_mysql zip opcache bcmath sockets exif 

RUN a2enmod rewrite

# Limpia la lista de paquetes y los archivos temporales
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configura el servidor Apache si es necesario
# ...

# Define el directorio de trabajo
WORKDIR /var/www

# Inicia el servidor Apache
CMD ["apache2-foreground"]
