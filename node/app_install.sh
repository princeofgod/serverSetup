#  app install for nodejs
cd /var/www

# clone project
read -p "Enter the url for git repo: " git_url
read -p "Enter the new app name: " app_name
sudo git clone $git_url $app_name

cd $app_name

# change branch to master
sudo git checkout master

# install packages
sudo npm i --legacy-peer-deps

# Create nginx config
read -p "Enter the name of the file: " nginx_file_name
read -p "Enter the ip address of the instance: " ip_address

cat > /etc/nginx/sites-available/$nginx_file_name <<EOF
server {
listen 80;
server_name $ip_address;
location / {
    proxy_pass http://localhost:4000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
}
}
EOF 
# Link config file
sudo ln -s /etc/nginx/sites-available/$nginx_file_name /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx

# 
echo "New app setup done..."