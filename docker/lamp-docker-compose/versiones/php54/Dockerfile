FROM php:5.4-apache

#Actualizamos
RUN apt-get -y --allow-unauthenticated update && apt-get upgrade -y --allow-unauthenticated

# Instalamos herramientas y librerias para Php5
RUN apt-get -y --allow-unauthenticated install --fix-missing apt-utils nano wget dialog \
    build-essential git curl libcurl3 libcurl3-dev zip \
    libmcrypt-dev libsqlite3-dev libsqlite3-0 mysql-client \
    zlib1g-dev libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libapache2-mod-rpaf libpng12-dev \
    && rm -rf /var/lib/apt/lists/*

# Utilizamos Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Extensiones para PHP5
RUN docker-php-ext-install curl \
    && docker-php-ext-install tokenizer \
    && docker-php-ext-install json \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_sqlite \
    && docker-php-ext-install mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install mbstring

# Habilitamos modulos de Apache
RUN a2enmod rewrite headers

RUN a2enmod rewrite rpaf

#Exponemos el puerto 80
EXPOSE 80
