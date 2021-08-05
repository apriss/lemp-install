#!/bin/bash

#INSTALL NGINX, MYSQL, PHP74 (LEMP-STACK) FOR RHEL 8 / ALAMA LINUX 8

dnf update
dnf install -y epel-release

# Install MariaDB database server
dnf install -y mariadb-server mariadb
systemctl enable mariadb
systemctl start mariadb
mysql_secure_installation

# Install NginX web server
dnf install -y nginx
systemctl enable nginx
systemctl start nginx
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

# Install PHP 8
dnf install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
# dnf module list php
dnf module reset php -y
dnf module enable php:remi-8.0 -y
dnf install -y php php-mysqlnd php-fpm php-opcache php-gd php-xml php-mbstring
systemctl enable php-fpm
systemctl start php-fpm
#nano /etc/php-fpm.d/www.conf
systemctl restart nginx
sudo systemctl restart php-fpm
