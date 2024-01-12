#!/bin/bash

# Check if the script is being run with root privileges
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root. Please use 'sudo' or run it as the root user."
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

# Install required package
# sudo apt install php-cli unzip
sudo apt-get install -y php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath unzip


# Install composer
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php

HASH=`curl -sS https://composer.github.io/installer.sig`

sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer


echo "Composer install ..."



# clone project
cd /var/www

read -p "Enter the git url for the project: " giturl
# read -p "Enter the name of the folder you want to clone to: " folder_name
sudo git clone $giturl $nginx_file_name
pwd
cd $nginx_file_name

read -p "Enter the git branch for checkout: " branch

sudo git checkout $branch

sudo composer install --ignore-platform-reqs

sudo nano .env

exit