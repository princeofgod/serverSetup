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


# Configure Nginx to use PHP
echo "setting up nginx ..."

# Create the nginx config
read -p "Enter the name of the file: " nginx_file_name
read -p "Enter the ip address of the instance: " ip_address

cat > /etc/nginx/sites-available/$nginx_file_name <<EOF
server {
  listen 80;
  server_name $ip_address;
  location / {
    proxy_pass http://localhost:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
  }
}
EOF

sudo ln -s /etc/nginx/sites-available/$nginx_file_name /etc/nginx/sites-enabled

# Restart Nginx to apply the configuration
systemctl restart nginx

echo "LEMP stack installation completed successfully with PHP 8.0 and MySQL (MariaDB)."

# Update package list
sudo apt update

source node/node_setup.sh

