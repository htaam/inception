FROM debian:bullseye

WORKDIR /var/www/

RUN apt-get update \
    && apt-get upgrade -yq \
    && apt-get install -yq wget openssl mariadb-client php php-fpm

RUN apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz \
    && rm -rf latest.tar.gz

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

COPY ./tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN rm /var/www/wordpress/wp-config-sample.php

RUN mkdir /run/php/ \
    && touch /run/php/php-fpm.pid

RUN chmod -R 755 /var/www

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm", "-F", "-R"]