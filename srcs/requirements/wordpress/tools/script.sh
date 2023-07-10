#!/bin/sh
sleep 10
set -x

if [ -f /usr/local/bin/.docker-entrypoint-finished ]; then
	rm -f /usr/local/bin/.docker-entrypoint-finished
	echo "Removed .docker-entrypoint-finished"
fi

# Checks if the config file has already been created by a previous run of this script
if [ -e /etc/php/7.4/fpm/pool.d/www.conf ]; then
	  echo "FastCGI Process Manager config already created"
else

    # Substitutes env variables and creates config file
    cat /www.conf | envsubst > /etc/php/7.4/fpm/pool.d/www.conf
	chmod 755 /etc/php/7.4/fpm/pool.d/www.conf
fi

# Checks if wp-config.php file has already been created by a previous run of this script
if [ -e wp-config.php ]; then
	  echo "Wordpress config already created"
      # Add line to disable comment moderation
else
    # Create the wordpress config file
    wp config create --allow-root \
        --dbname=$db_name \
        --dbuser=$db_user \
        --dbpass=$db_pwd \
        --dbhost=$db_host
    chmod 600 wp-config.php
fi


# Check if wordpress is already installed
if wp core is-installed --allow-root; then
	  echo "Wordpress core already installed"
else

    # Installs wordpress
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USR \
        --admin_email=$WP_ADMIN_EMAIL \
        --admin_password=$WP_ADMIN_PWD

    # create a new author user
    wp user create --allow-root \
        $WP_USR \
        $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PWD

    # Turns off debugging which is needed when using CLI from container
    wp config set WORDPRESS_DEBUG false --allow-root
fi

# Check if author user has already been created by a previous run of this script
if !(wp user list --field=user_login --allow-root | grep $WP_USR); then

	# create a new author user
    wp user create --allow-root \
        $WP_USR \
        $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PWD

fi

wp plugin update --all --allow-root

    wp option set comment_moderation 0 --allow-root
    wp option set moderation_notify 0 --allow-root
    wp option set comment_previously_approved 0 --allow-root
    wp option set close_comments_for_old_posts 0 --allow-root   
    wp option set close_comments_days_old 0 --allow-root

# Sets the correct port to listen to nginx
sed -ie 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 0.0.0.0:9000/g' \
/etc/php/7.4/fpm/pool.d/www.conf

chown -R wpg:wpg /var/www/html/*

touch /usr/local/bin/.docker-entrypoint-finished
echo "Created .docker-entrypoint-finished"

exec "$@"