#!/bin/bash

#INSTALL NGINX, MYSQL/MARIADB, PHP (LEMP-STACK) FOR UBUNTU20 20.04 

sudo apt update

#STEP 1. INSTALL NGINX WEB SERVER
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTPS'
sudo systemctl start nginx
sudo systemctl enable nginx

#STEP 2. iNSTALL PHP MODULE
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
echo -n "Please select PHP version do want to install? (1. PHP 7.4, 2. PHP 8, 3. Skip) " 
read ans
case $ans in
         1)
	    sudo apt install php7.4-{cgi,cli,curl,common,fpm,gd,json,ldap,mbstring,mysql,opcache,readline,redis,xml,zip} -y
            sudo systemctl start php7.4-fpm
	    sudo systemctl enable php7.4-fpm
            sudo systemctl restart nginx
	 ;;	
              
	 2)
	    sudo apt install php8.0-{cgi,cli,curl,common,fpm,gd,ldap,mbstring,mysql,opcache,readline,redis,xml,zip} -y
            sudo systemctl start php8.0-fpm
	    sudo systemctl enable php8.0-fpm
            sudo systemctl restart nginx
	 ;;
	      
	 3)
	    exit;;
	      
	 *)
	    echo "Invalid Option"
        ;;

esac

echo "<?php phpinfo(); ?>" > /var/www/html/info.php

#STEP 3 INSTALL DATABASE SERVER
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
