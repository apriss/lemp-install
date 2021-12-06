#!/bin/bash

chown -R www-data:www-data /var/www
read -p "Enter domain name : " domain
doc="$""document_root""$""fastcgi_script_name";
a="$""uri";
b="$""uri/";
c="/index.php?""$""args";

read -p "Please select (1. No SSL, 2. SSL with self sign, 3. Skip)" ans

case $ans in
1)
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

ufw allow 'Nginx HTTP'
;;

2)
#Generate and Self-Sign an SSL Certificate

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt

openssl dhparam -out /etc/nginx/dhparam.pem 4096

#Configure Nginx to Use Private Key and SSL Certificate

cat > /etc/nginx/snippets/self-signed.conf << EOF
ssl_certificate /etc/ssl/certs/nginx.crt;
ssl_certificate_key /etc/ssl/private/nginx.key;
ssl_protocols TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
ssl_session_timeout 10m;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
ssl_dhparam /etc/nginx/dhparam.pem;
ssl_ecdh_curve secp384r1;
EOF

cat > /etc/nginx/sites-available/$domain << EOF
server {
        listen 443 ssl;
        listen [::]:443 ssl;
        include snippets/self-signed.conf;
        server_name $domain www.$domain;
        root /var/www/$domain/public_html/;
        index index.html index.php index.htm;
        
        location / {
                try_files $a $b $c;                
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

ufw allow 'Nginx HTTPS'
;;

3)
exit;;
	      
*)
echo "Invalid Option"
;;

esac
ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default

systemctl restart nginx
nginx -t
