FROM ubuntu:focal
MAINTAINER Fall Lewis YOMBA <fallewi@gmail.com>

RUN apt-get update; \
    apt-get -y install  openssh-server passwd sudo vim; \
    apt-get -qq clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y iproute2 git curl iputils-ping net-tools wget curl
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN systemctl enable ssh.service;

RUN useradd --create-home -s /bin/bash vagrant; \
    echo -e "vagrant\nvagrant" | (passwd --stdin vagrant); \
    echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant; \
    chmod 440 /etc/sudoers.d/vagrant

RUN mkdir -p /home/vagrant/.ssh; \
    chmod 700 /home/vagrant/.ssh
ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys; \
    chown -R vagrant:vagrant /home/vagrant/.ssh

RUN apt-get install nginx mariadb-server php php-fpm php-curl php-mysql php-gd php-mbstring php-xml php-imagick php-zip php-xmlrpc -y
RUN systemctl enable php7.4-fpm;
RUN systemctl enable nginx;

ADD conf/wordpress /etc/nginx/sites-available/wordpress
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/


WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
tar -zxvf latest.tar.gz && \
rm latest.tar.gz && \
mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

ADD conf/wp-config.php /var/www/html/wordpress/wp-config.php

#RUN usermod -a -G systemd-journal www-data
RUN mkdir -p /tmp/php
RUN sed -i 's#/run/php#/tmp/php#' /etc/php/7.4/fpm/php-fpm.conf
RUN sed -i 's#/run/php#/tmp/php#' /etc/php/7.4/fpm/pool.d/www.conf

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]
