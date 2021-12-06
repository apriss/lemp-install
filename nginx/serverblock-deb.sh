#!/bin/bash

chown -R www-data:www-data /var/www
doc="$""document_root""$""fastcgi_script_name";
a="$""uri";
b="$""uri/";
c="/index.php?""$""args

read -p "Enter domain name : " domain

read -p "Please select (1. No SSL, 2. SSL with self sign, 3. Skip) " ans
case $ans in
1)
cat > /etc/apache2/sites-available/$domain.conf << EOF
<VirtualHost *:80>
        
ServerAdmin $sa
ServerName $domain
ServerAlias www.$domain
DocumentRoot /var/www/$domain/public_html/
DirectoryIndex index.php
            
<Directory> /var/www/$domain/public_html/>
Options Indexes FollowSymLinks MultiViews
AllowOverride All
Order allow,deny
allow from all
</Directory>
<FilesMatch \.php$>
SetHandler "proxy:unix:/run/php/php8.0-fpm.sock|fcgi://localhost"
</FilesMatch>
    
ErrorLog ${APACHE_LOG_DIR}/$domain_error.log
CustomLog ${APACHE_LOG_DIR}/$domain_access.log combined
</VirtualHost>
EOF
	
a2dissite 000-default
a2ensite $domain
;;	
              
2)	      
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
cat > /etc/apache2/conf-available/ssl-params.conf << EOF
# from https://cipherli.st/
# and https://raymii.org/s/tutorials/Strong_SSL_Security_On_Apache2.html
SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3
SSLHonorCipherOrder On
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
#Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains; preload"
Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains"
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
# Requires Apache >= 2.4
SSLCompression off
SSLSessionTickets Off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
SSLOpenSSLConfCmd DHParameters "/etc/ssl/certs/dhparam.pem"
EOF
        
cat > /etc/apache2/sites-available/$domain.conf << EOF
<IfModule mod_ssl.c>
<VirtualHost _default_:443>
ServerAdmin $sa
ServerName $domain
DocumentRoot /var/www/$domain/public_html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
SSLEngine on
SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
SSLCertificateKeyFile   /etc/ssl/private/apache-selfsigned.key
<FilesMatch "\.(cgi|shtml|phtml|php)$">
SSLOptions +StdEnvVars
</FilesMatch>
<Directory /usr/lib/cgi-bin>
SSLOptions +StdEnvVars
</Directory>
BrowserMatch "MSIE [2-6]" \
nokeepalive ssl-unclean-shutdown \
downgrade-1.0 force-response-1.0
</VirtualHost>
</IfModule>	
EOF
	
a2enmod ssl
a2enmod headers
a2dissite 000-default
a2ensite $domain
a2enconf ssl-params	
;;     
        
3)
exit;;
	      
*)
echo "Invalid Option"
;;

esac

systemctl reload apache2
apache2ctl configtest
