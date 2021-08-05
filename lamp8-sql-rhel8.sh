#!/bin/bash

#INSTALL APACHE, MYSQL, PHP8 (LEMP-STACK) FOR RHEL 8 / ALAMA LINUX 8

dnf update
dnf install -y epel-release

#Install Apache Web Server
dnf install -y httpd httpd-tools
systemctl start httpd
systemctl enable httpd

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# Install MySQL  Database Server
dnf install mysql-server mysql
sudo systemctl start mysqld
sudo systemctl enable mysqld
mysql_secure_installation

# Install PHP 8
dnf install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
# dnf module list php
dnf module reset php -y
dnf module enable php:remi-8.0 -y
dnf install -y php php-mysqlnd php-fpm php-opcache php-gd php-xml php-mbstring php-common php-cli php-curl
systemctl enable php-fpm
systemctl start php-fpm
