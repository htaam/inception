#!/bin/bash

# Start the MariaDB service
mysqld_safe --datadir=/var/lib/mysql &

# Wait for MariaDB to start
echo a
sleep 5
echo b
# Check if the mysql.user table exists
if ! mysql --user=root -e "SELECT 1 FROM mysql.user LIMIT 1" >/dev/null 2>&1; then
    # Run mysql_upgrade instead of mysql_install_db
    mysql_upgrade

    # Start the service again
    mysqladmin -uroot shutdown
    mysqld_safe --datadir=/var/lib/mysql &
    
    # Wait for MariaDB to start
    sleep 5
fi
echo c
# Set root password and perform other necessary configurations
mysql --user=root << EOF
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '$db_root_pwd';
FLUSH PRIVILEGES;
EOF

# Stop the MariaDB service
mysqladmin -uroot -p$db_root_pwd shutdown

# Execute the provided command or start the default command
exec "$@"
