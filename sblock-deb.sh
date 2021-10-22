#!/bin/bash

read -p "Enter domain name : " domain

cat > /etc/nginx/sites-available/$domain << EOF
server {
        listen 80 
        root /var/www/html;
        index index.html index.php index.htm index.nginx-debian.html;

        server_name $domain;

        location / {
                try_files $uri $uri/ =404;
        }
        
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
        
}
EOF

ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default
