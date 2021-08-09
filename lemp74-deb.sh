#!/bin/bash

#INSTALL NGINX, MYSQL/MARIADB, PHP74 (LEMP-STACK) FOR UBUNTU20/DEBIAN

sudo apt update

# Install NginX Web Server
sudo apt install nginx -y
#sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

# Install PHP 7.4 Modules
sudo apt install php7.4 php7.4-fpm php7.4-mysql php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl -y
sudo systemctl start 
sudo systemctl enable nginx

# Install MariaDB  Database Server
echo -n "Please select database server do want to install? (1. MariaDB, 2. Mysql, 3 Finish) " 
read ans
case $ans in
        1)
	      sudo apt install mariadb-server -y
              sudo systemctl start mariadb
              sudo systemctl enable mariadb
	      mysql_secure_installation
	      ;;	
        
	2)
	      sudo apt install mysql-server -y
              sudo systemctl start mysql
              sudo systemctl enable mysql
	      mysql_secure_installation
	      ;;
	      
	3)
	      exit;;
	      
	*)
	      echo "Invalid Option"
              ;;

esac
