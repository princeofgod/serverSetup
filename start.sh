#!/bin/bash

echo "Welcome to server setup" 
read -p "What kind of app do you want to setup? (1 = php, 2 = nodejs): " app_type

# if [[ "$app_type" != 1 ]]
if [[ "$app_type" == "1" ]]
then 
    echo "running the php script..."
    source php/nginx.sh

elif [[ "$app_type" == "2" ]] 
then
    echo "running the nodejs script..."
    cd node
else
    echo "provided response is invalid, please select between 1 and 2"
    exit 1
fi
