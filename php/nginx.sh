#!/bin/bash

# Update package lists
apt-get update

# Install Nginx
echo "Installing nginx ..."
apt-get install -y nginx

# Check if Nginx installation was successful
if systemctl is-active --quiet nginx; then
  echo "Nginx installed successfully."
else
  echo "Failed to install Nginx."
  exit 1
fi


# Configure Nginx to use PHP
echo "setting up nginx ..."

# Create the nginx config
read -p "Enter the name of the file: " nginx_file_name
read -p "Enter the ip address of the instance: " ip_address

cat > /etc/nginx/sites-available/$nginx_file_name <<EOF
server {
    root /var/www/$nginx_file_name/public;
    index index.php index.html index.htm index.nginx-debian.html;
    server_name $ip_address;
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    location /phpmyadmin {
        index index.php index.html index.htm;
        root /usr/share;
    }
    location ~ /\.ht {
        deny all;
    }
}

EOF

#Link the nginx config
sudo ln -s /etc/nginx/sites-available/$nginx_file_name /etc/nginx/sites-enabled

# Restart Nginx to apply the configuration
systemctl restart nginx

echo "LEMP stack installation completed successfully with PHP 8.0 and MySQL (MariaDB)."

# Update package list
sudo apt update

source ./php_setup.sh


