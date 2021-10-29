#!/bin/bash

#INSTALL NGINX, MYSQL/MARIADB, PHP (LEMP-STACK) FOR RHEL 8 / ALAMA LINUX 8

dnf install -y epel-release
dnf check-update

# Install Nginx Web Server
dnf install -y nginx
systemctl start nginx
systemctl enable nginx

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# Install PHP Module
dnf install -y http://rpms.remirepo.net/enterprise/remi-release-8.rpm
dnf check-update
dnf module reset php -y
echo -n "Please select PHP version do want to install? (1. PHP 7.4, 2. PHP 8, 3. Skip) " 
read ans
case $ans in
         1)
	    dnf module enable php:remi-7.4 -y
            dnf install php-{cgi,cli,curl,common,fpm,gd,json,ldap,mbstring,opcache,readline,xml,zip} -y
            systemctl enable php-fpm
            systemctl start php-fpm
            systemctl restart nginx
	 ;;	
              
	 2)
	    dnf module enable php:remi-8.0 -y
            dnf install php-{cgi,cli,curl,common,fpm,gd,ldap,mbstring,opcache,readline,xml,zip} -y
            systemctl enable php-fpm
            systemctl start php-fpm
            systemctl restart nginx        
	 ;;
	      
	 3)
	    exit;;
	      
	 *)
	    echo "Invalid Option"
         ;;

esac

#echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/info.php

# Install Database Server
echo -n "Please select database server do want to install? (1. MariaDB, 2. Mysql, 3. Finish) " 
read ans
case $ans in
        1)
	   dnf install mariadb-server -y
           systemctl start mariadb
           ssystemctl enable mariadb
	   mysql_secure_installation
	;;	
        
	2)
	   dnf install mysql-server -y
           systemctl start mysql
           systemctl enable mysql
	   mysql_secure_installation
	;;
	      
	3)
	   exit;;
	      
	*)
	   echo "Invalid Option"
        ;;

esac

#nano /etc/php-fpm.d/www.conf
