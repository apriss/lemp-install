#!/bin/bash

#INSTALL NGINX, MYSQL, PHP74 (LEMP-STACK) FOR UBUNTU20

sudo apt update

# Install Nginx Web Server
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl is-enable apache2
sudo ufw allow in "Apache"

# Install PHP 7.4 Modules
sudo apt install php7.4 php7.4-fpm php7.4-mysql php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl -y
sudo systemctl restart apache2

# Install MySQL Database Server
sudo apt install mariadb-server -y
sudo mysql_secure_installation
sudo systemctl start mysql
sudo systemctl enable mysql
