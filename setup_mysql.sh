#!/bin/bash
# Initialize the database directories
mysql_install_db

# Start the MySQL server in the background
/usr/bin/mysqld_safe &
sleep 10  # Give time for the server to start

# Setup the database and user
mysql -uroot <<EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

# Kill all MySQL processes (gracefully)
mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown