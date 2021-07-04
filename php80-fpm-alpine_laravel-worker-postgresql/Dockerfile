FROM php:8.0-fpm-alpine

# mongodb
#RUN apk --update add --virtual build-dependencies build-base openssl-dev autoconf \
#  && pecl install mongodb \
#  && docker-php-ext-enable mongodb \
#  && apk del build-dependencies build-base openssl-dev autoconf \
#  && rm -rf /var/cache/apk/*

# postgres with composer
RUN set -eux && \
    apk add --no-cache --virtual=.build postgresql-dev libzip-dev libjpeg-turbo-dev libpng-dev build-base && \
    apk add --no-cache postgresql-libs libzip tzdata libjpeg-turbo libpng autoconf && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-install gd opcache pdo pdo_pgsql pgsql zip && \
    apk del --purge .build

RUN { \
    echo '[opcache]'; \
    echo 'opcache.jit_buffer_size = 128M'; \
    echo 'opcache.enable = 1'; \
    echo 'opcache.enable_cli = 1'; \
    echo 'opcache.validate_timestamps = 1'; \
    echo 'opcache.revalidate_freq = 0'; \
    echo 'opcache.optimization_level = 0x7FFFBFFF'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

RUN mkdir /work

CMD ["php","/work/artisan","queue:work"]