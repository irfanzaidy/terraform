#!/bin/bash
set -e 
apt update -y
apt install -y nginx
systemctl restart nginx
systemctl enable nginx
ufw allow 'Nginx Full'
echo '<h1> Hlo welcome to nginx form terraform ! </h1>' > /var/www/html/index.html
