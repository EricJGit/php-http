ARG PHP_IMAGE=php:8-fpm

FROM ${PHP_IMAGE} as php

ARG USER_ID=1001
ARG USER_NAME=php
ARG GROUP_ID=1001
ARG GROUP_NAME=php

RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} \
    && useradd -m -u ${USER_ID} -g ${GROUP_NAME} ${USER_NAME}

# Maj list paquet
RUN apt-get update \
    && apt-get install -y wget unzip libssh-dev \
    # xdebug
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    # zip
    && apt-get install -y zlib1g-dev libzip-dev \
    && docker-php-ext-install zip \
    # Git
    && apt-get -y install git

ARG XdebugFile=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "xdebug.mode=develop" >> $XdebugFile \
    && echo "xdebug.start_with_request=on" >> $XdebugFile \
    && echo "xdebug.discover_client_host=on" >> $XdebugFile

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

COPY ./docker/php-overide.ini $PHP_INI_DIR/conf.d/php-overide.ini

# clean
RUN rm -rf /var/lib/apt/lists/* \
    && apt-get clean

ENV PATH "$PATH:/var/www/html/"

USER ${USER_ID}
