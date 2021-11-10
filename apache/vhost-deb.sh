#!/bin/bash

read -p "Enter domain name : " domain
read -p "Enter server admin mail address : " sa

cat > /etc/apache2/sites-available/$domain.conf << EOF
<VirtualHost *:80>
   ServerAdmin $sa
   ServerName $domain
   ServerAlias www.$domain
   DocumentRoot /var/www/$domain/public_html/
   DirectoryIndex index.php

   <Directory /var/www/site1.your_domain>
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

a2ensite $domain

systemctl reload apache2
