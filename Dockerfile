FROM php:fpm
MAINTAINER docker@mikeditum.co.uk

RUN apt-get update && apt-get install -y \
    git \
    libmagickwand-dev

RUN pecl install imagick && \
    docker-php-ext-enable imagick

RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd
RUN docker-php-ext-install exif
RUN docker-php-ext-install zip

RUN mkdir -p /code/lychee

COPY php_lychee.ini /usr/local/etc/php/conf.d/lychee.ini

RUN git clone https://github.com/electerious/Lychee.git /code/lychee

RUN mv /code/lychee/uploads /uploads && \
    mv /code/lychee/data /data && \
    ln -s /uploads /code/lychee/uploads && \
    ln -s /data /code/lychee/data && \
    chmod -R 777 /uploads /code/lychee/uploads && \
    chmod -R 777 /data /code/lychee/data

VOLUME ["/code/lychee", "/upload/", "/data"]
