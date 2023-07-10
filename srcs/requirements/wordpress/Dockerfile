FROM debian:bullseye
ARG	WORDPRESS_VERSION=6.2.2

RUN apt-get update && apt-get install -y \
	gettext \
	php \
	php-fpm \
	php-cli \
	wget \
	curl \
	procps \
	php-curl \
	php-mysql \
	php-mbstring \
	php-xml \
	php-gd \
	sendmail \
	mariadb-client \
	gettext-base \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir /run/php

# - downloads the wordpress command line interface and
# - gives execution permission to where it's downloaded at

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	--output-document=/usr/local/bin/wp \
  && chmod +x /usr/local/bin/wp

RUN mkdir -p /run/php /var/www/html/wordpress \
  && chmod -R 755 /var/www/html/

# - add the "wpg" group and user
RUN addgroup --system wpg \
  && adduser --system wpg

# - copy the config file to container root as a template file
COPY ./conf/www.conf /www.conf

# - Sets the working directory where I want to download wp core
WORKDIR /var/www/html/wordpress

# - downloads wp core
RUN wp core download --allow-root --version=$WORDPRESS_VERSION

# - copies the entrypoint script
COPY tools/script.sh /usr/local/bin/

# - sets the execution permission to the entrypoint script
RUN chmod +x /usr/local/bin/script.sh

# - removes default www.conf
RUN rm -f /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT [ "script.sh" ]

CMD [ "/usr/sbin/php-fpm7.4", "-F" ]