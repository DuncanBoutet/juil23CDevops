#!/bin/bash

# Start MariaDB
service mysql start

# Check if databases are present, if not create them
if [ ! "$(ls -A /var/lib/mysql)" ]; then
	echo "MariaDB data not found, installing..."
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	# Run SQL commands
	cat > /tmp/sql <<EOF
USE mysql;
DELETE FROM user WHERE user='';
UPDATE user SET password=PASSWORD("\${MYSQL_ROOT_PASSWORD}") WHERE user='root';
FLUSH PRIVILEGES;
CREATE DATABASE \${MYSQL_DATABASE};
GRANT ALL ON \${MYSQL_DATABASE}.* TO '\${MYSQL_USER}'@'%' IDENTIFIED BY '\${MYSQL_PASSWORD}';
EOF

	# Execute SQL commands
	mysql < /tmp/sql
fi

# Start MariaDB background process
/usr/bin/mysqld_safe