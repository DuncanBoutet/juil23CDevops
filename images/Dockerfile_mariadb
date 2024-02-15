# Base image
FROM ubuntu:latest

# Updating and installing necessary software
RUN apt-get update && apt-get install -y \
	mariadb-server \
	mariadb-client


# Allow to use all databases
RUN echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

# Bind MariaDB to all interfaces
RUN echo "bind-address=0.0.0.0" >> /etc/mysql/mariadb.conf.d/99_mariadb.cnf

# Copy shell script to image and set it to entrypoint
COPY images/conf/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Expose port 3306
EXPOSE 3306