#!/bin/bash

# initialize the MySQL data directory and create the system tables if they don't exist yet
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

# start the service, run the mysql_secure_installation equivalent and set up database and privileged user
if [ ! -d "/var/lib/mysql/$db_name" ]; then
    service mariadb start

    chown -R mysql:mysql /var/lib/mysql

    mysql --user=root --password=$db_root_pwd << EOF
CREATE DATABASE IF NOT EXISTS $db_name;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$db_root_pwd';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'%' IDENTIFIED BY '$db_pwd' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysqladmin -p$db_root_pwd shutdown

    # Stop the service to allow running mysqld in Dockerfile CMD
    service mariadb stop
fi

exec "$@"

