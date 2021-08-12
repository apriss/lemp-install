#!/bin/bash

#INSTALL APACHE, MYSQL, PHP (LEMP-STACK) FOR RHEL 8 / ALAMA LINUX 8

dnf update
dnf install -y epel-release

# Install Apache Web Server
dnf install -y httpd httpd-tools
systemctl start httpd
systemctl enable httpd

firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

# Install PHP 8
dnf install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
dnf module reset php -y
echo -n "Please select PHP version do want to install? (1. PHP 7.4, 2. PHP 8, 3. Skip) " 
read ans
case $ans in
         1)
	    dnf module enable php:remi-7.4 -y
            dnf install libapache2-mod-php php-{cgi,cli,curl,common,fpm,gd,json,ldap,mbstring,mysql,opcache,readline,redis,xml,zip}-y
            systemctl start php-fpm
	    systemctl enable php-fpm
            systemctl restart httpd
	 ;;	
              
	 2)
	    dnf module enable php:remi-8.0 -y
            dnf install libapache2-mod-php php-{cgi,cli,curl,common,fpm,gd,ldap,mbstring,mysql,opcache,readline,redis,xml,zip} -y
            systemctl start php-fpm
	    systemctl enable php-fpm
            systemctl restart httpd
	 ;;
	      
	 3)
	    exit;;
	      
	 *)
	    echo "Invalid Option"
         ;;

esac

echo "<?php phpinfo(); ?>" > /var/www/html/info.php

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

