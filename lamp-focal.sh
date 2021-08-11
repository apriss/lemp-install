!/bin/bash

#INSTALL APACHE, MYSQL / MARIADB, PHP FOR UBUNTU20 20.04 DEBIAN 10 

#Step 1. INSTALL APACHE WEB SERVER
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo ufw allow 'Apache Secure'

#STEP 2 iNSTALL PHP MODULE
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php
sudo apt update
echo -n "Please select PHP version do want to install? (1. PHP 7.4, 2. PHP 8, 3. Skip) " 
read ans
case $ans in
         1)
	    sudo apt install php7.4 php7.4-fpm php7.4-mysql php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-mbstring php7.4-xml php7.4-gd php7.4-curl -y
            sudo systemctl restart apache2
            sudo a2enmod proxy_fcgi setenvif
            sudo a2enconf php7.4-fpm
	 ;;	
              
	 2)
	    sudo apt install libapache2-mod-php8.0 php8.0-{cgi,cli,curl,common,fpm,gd,ldap,mbstring,mysql,readline,xml,zip} -y
            sudo systemctl restart apache2
            sudo a2enmod proxy_fcgi setenvif
            sudo a2enconf php8.0-fpm
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
