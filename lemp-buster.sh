!/bin/bash

#INSTALL APACHE, MYSQL / MARIADB, PHP FOR UBUNTU20 20.04

#Step 1. INSTALL APACHE WEB SERVER
apt update
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
ufw allow 'Apache Secure'

#STEP 2 iNSTALL PHP MODULE
apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
apt update
echo -n "Please select PHP version do want to install? (1. PHP 7.4, 2. PHP 8, 3. Skip) " 
read ans
case $ans in
         1)
	    apt install libapache2-mod-php7.4 php7.4-{cgi,cli,curl,common,fpm,gd,json,ldap,mbstring,mysql,opcache,readline,redis,xml,zip}-y
            systemctl restart apache2
            a2enmod proxy_fcgi setenvif
            a2enconf php7.4-fpm
	 ;;	
              
	 2)
	    apt install libapache2-mod-php8.0 php8.0-{cgi,cli,curl,common,fpm,gd,ldap,mbstring,mysql,opcache,readline,redis,xml,zip} -y
            systemctl restart apache2
            a2enmod proxy_fcgi setenvif
            a2enconf php8.0-fpm
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
