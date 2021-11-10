#!/bin/bash

read -p "Enter domain name : " domain

cat > /etc/apache2/sites-available/$domain << EOF
EOF<VirtualHost *:80>
#  ServerAdmin webmaster@ostechnix1.lan
   ServerName $domain
   ServerAlias www.$domain
   DocumentRoot /var/www/$domain/public_html/
ErrorLog ${APACHE_LOG_DIR}/error.log
 CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
