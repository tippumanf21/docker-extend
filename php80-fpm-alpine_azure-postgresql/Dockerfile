FROM php:8.0-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer

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
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-install gd opcache pdo pdo_pgsql pgsql zip && \
    pecl install xdebug && \
    apk del --purge .build && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.0.12

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

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apk add openssh \
     && echo "root:Docker!" | chpasswd 
     
RUN { \
    echo 'Port            2222'; \
    echo 'ListenAddress       0.0.0.0'; \
    echo 'LoginGraceTime      180'; \
    echo 'X11Forwarding       yes'; \
    echo 'Ciphers aes128-cbc,3des-cbc,aes256-cbc,aes128-ctr,aes192-ctr,aes256-ctr'; \
    echo 'MACs hmac-sha1,hmac-sha1-96'; \
    echo 'StrictModes         yes'; \
    echo 'SyslogFacility      DAEMON'; \
    echo 'PasswordAuthentication  yes'; \
    echo 'PermitEmptyPasswords    no'; \
    echo 'PermitRootLogin     yes'; \
    echo 'Subsystem sftp internal-sftp'; \
    } > /etc/ssh/sshd_config 
     
RUN { \
    echo '#!/bin/sh'; \
    echo 'php-fpm -D'; \
    echo 'ssh-keygen -A'; \
    echo '/usr/sbin/sshd -D'; \
    } > /tmp/docker-entrypoint.sh
     
RUN chmod 777 /tmp/docker-entrypoint.sh
EXPOSE  2222
#CMD ["ssh-keygen", "-A"]
#CMD ["/usr/sbin/sshd"]
CMD ["/tmp/docker-entrypoint.sh"]