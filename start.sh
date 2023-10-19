#!/bin/bash

echo "Welcome to server setup" 

read -p "What kind of app do you want to setup? (1 = php, 2 = nodejs): " app_type
read -p "Is this a fresh install? (yes / no) " install_type



if [[ "$app_type" = "1" ]]

# if [[ "$app_type" == "1" ]] && [[ "install_type" == "yes" ]];
then 
    echo "running the php script..."
    source php/nginx.sh
elif [[ "$app_type" == "2" ]]
# elif [[ "$app_type" == "2" ]] && [[ "install_type" == "yes" ]];
then
    echo "running the nodejs script..."
    source node/nginx.sh

# elif [[ "$app_type" == "1" ]] && [[ "install_type" == "no" ]];
# then
#     # app install for php

# elif [[ "$app_type" == "1" ]] && [[ "install_type" == "no" ]];
# then
#     # app install for nodejs
#     cd /var/www

#     # clone project
#     read -p "Enter the url for git repo: " git_url
#     read -p "Enter the new app name: " app_name
#     sudo git clone $git_url $app_name

#     cd $app_name

#     # change branch to master
#     sudo git checkout master
    
#     # install packages
#     sudo npm i --legacy-peer-deps

#     # Create nginx config
#     read -p "Enter the name of the file: " nginx_file_name
#     read -p "Enter the ip address of the instance: " ip_address

#     cat > /etc/nginx/sites-available/$nginx_file_name <<EOF
#     server {
#     listen 80;
#     server_name $ip_address;
#     location / {
#         proxy_pass http://localhost:4000;
#         proxy_http_version 1.1;
#         proxy_set_header Upgrade \$http_upgrade;
#         proxy_set_header Connection 'upgrade';
#         proxy_set_header Host \$host;
#         proxy_cache_bypass \$http_upgrade;
#     }
#     }
# EOF 
#     # Link config file
#     sudo ln -s /etc/nginx/sites-available/$nginx_file_name /etc/nginx/sites-enabled
#     sudo nginx -t
#     sudo systemctl restart nginx
    
#     # 
#     echo "New app setup done..."
fi

