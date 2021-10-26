#!/bin/bash

chown -R www-data:www-data /var/www

read -p "Enter domain name : " domain

doc="$document_root$fastcgi_script_name";

cat > /etc/nginx/sites-available/$domain << EOF
server {
        listen 80;
        server_name $domain www.$domain;
        root /var/www/$domain/public_html/;
        index index.html index.php index.htm;
        
        location / {
                try_files $uri $uri/ /index.php?$args;
                
        }
        
        location ~ \.php$ {
            fastcgi_pass unix:/run/php/php8.0-fpm.sock; 
            fastcgi_param SCRIPT_FILENAME $doc;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
        }
        
        location ~ /\.ht {
                deny all;
        }
        
}
EOF

ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default


