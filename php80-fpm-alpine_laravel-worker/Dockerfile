FROM php:8.0-fpm-alpine

# mongodb
RUN apk --update add --virtual build-dependencies build-base openssl-dev autoconf \
  && pecl install mongodb \
  && docker-php-ext-enable mongodb \
  && apk del build-dependencies build-base openssl-dev autoconf \
  && rm -rf /var/cache/apk/*

# postgres with composer
RUN set -eux && \
    apk add --no-cache --virtual=.build postgresql-dev libzip-dev libjpeg-turbo-dev libpng-dev build-base && \
    apk add --no-cache postgresql-libs libzip tzdata libjpeg-turbo libpng autoconf && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ && \
    docker-php-ext-install gd pdo pdo_pgsql pgsql zip && \
    apk del --purge .build

RUN mkdir /work

CMD ["php","/work/artisan","queue:work"]