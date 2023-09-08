#!/bin/bash

# Check if the script is being run with root privileges
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root. Please use 'sudo' or run it as the root user."
  exit 1
fi

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

# Install PHP and required extensions
echo "Installing php ..."
apt-get install -y php8.1-fpm php8.1-mysql

# Check if PHP installation was successful
if systemctl is-active --quiet php8.1-fpm; then
  echo "PHP installed successfully."
else
  echo "Failed to install PHP."
  exit 1
fi

# Configure Nginx to use PHP
echo "setting up nginx ..."
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }
}
EOF

# Restart Nginx to apply the configuration
systemctl restart nginx

echo "LEMP stack installation completed successfully with PHP 8.0 and MySQL (MariaDB)."

# Update package list
sudo apt update


# Install required package
sudo apt install php-cli unzip


# Install composer
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php

HASH=`curl -sS https://composer.github.io/installer.sig`

sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer


echo "Composer install ..."
exit