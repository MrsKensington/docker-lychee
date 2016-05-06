FROM mrskensington/docker-php-with-ext
MAINTAINER docker@mikeditum.co.uk

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

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
