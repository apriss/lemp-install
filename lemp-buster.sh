!/bin/bash

#INSTALL APACHE, MYSQL / MARIADB, PHP FOR UBUNTU20 20.04

#Step 1. INSTALL APACHE WEB SERVER
apt update
apt install nginx -y
systemctl start nginx
systemctl enable nginx
sudo ufw allow 'Nginx HTTPS'

#STEP 2 iNSTALL PHP MODULE
apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
apt update
echo -n "Please select PHP version do want to install? (1. PHP 7.4, 2. PHP 8, 3. Skip) " 
read ans
case $ans in
         1)
	    apt install php7.4-{cgi,cli,curl,common,fpm,gd,json,ldap,mbstring,mysql,opcache,readline,redis,xml,zip} -y
            systemctl start php7.4-fpm
	    systemctl enable php-fpm
	    systemctl restart nginx
	 ;;	
              
	 2)
	    apt install php8.0-{cgi,cli,curl,common,fpm,gd,ldap,mbstring,mysql,opcache,readline,redis,xml,zip} -y
            systemctl start php8.0-fpm
	    systemctl enable php8.0-fpm
	    systemctl restart nginx
	 ;;
	      
	 3)
	    exit;;
	      
	 *)
	    echo "Invalid Option"
        ;;

esac

echo "<?php phpinfo(); ?>" > /var/www/html/info.php

#STEP 3 INSTALL DATABASE SERVER
echo -n "Please select database server do want to install? (1. MariaDB, 2. Mysql, 3. Finish) " 
read ans
case $ans in
        1)
	   apt install mariadb-server -y
           systemctl start mariadb
           systemctl enable mariadb
	   mysql_secure_installation
	;;	
        
	2)
	   apt install mysql-server -y
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
