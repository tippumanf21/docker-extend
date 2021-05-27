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
  docker-php-ext-install gd pdo pdo_\tpgsql pgsql zip && \
  pecl install xdebug && \
  docker-php-ext-enable xdebug && \
  apk del --purge .build && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.0.12

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