#!/bin/bash

# Check if the script is being run with root privileges
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root. Please use 'sudo' or run it as the root user."
  exit 1
fi

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=18
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt-get update
sudo apt-get install nodejs -y

# clone project
cd /var/www

read -p "Enter the git url for the project: " giturl
read -p "Enter the name of the folder you want to clone to: " folder_name
sudo git clone $giturl $folder_name
cd $folder_name

sudo git checkout master

sudo npm i --legacy-peer-deps

sudo npm i pm2@latest -g

read -p "What stack is this? (1 = frontend, 2 = backend): " stack

if [[ "$stack" == "2" ]] then
# create env
sudo nano config.env
fi









