!/bin/bash

# allow external connection
sed -ie 's/bind-address/#bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -ie 's/port/#port/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# initialize the MySQL data directory and create the system tables if they don't exist yet
if [ ! -d "/var/lib/mysql/mysql" ]; then

    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

fi

# start the service, run the mysql_secure_installation equivalent and set up database and privileged user
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then

service mysql start

# Configure root password
# Deny remote root access
# Delete anonymours users
# Configure mysql and create database and user with set permissions
# Remove test database
mysql --user=root << _EOF_
UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='root' AND host='localhost';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
_EOF_

chown -R mysql:mysql /var/lib/mysql

mysql --user=root --password=$MYSQL_ROOT_PASSWORD << _EOF_
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
GRANT USAGE ON *.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
_EOF_

# Needed to stop service in order to run CMD mysqld in Dockerfile
service mysql stop
fi

exec "$@"