#!/bin/bash

sed -i s/MYSQL_DATABASE/${MYSQL_DATABASE}/g /var/www/wordpress/wp-config.php
sed -i s/MYSQL_USER/${MYSQL_USER}/g /var/www/wordpress/wp-config.php
sed -i s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g /var/www/wordpress/wp-config.php
chown -R www-data:www-data /var/www/wordpress

exec "$@"