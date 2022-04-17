#!/bin/bash
#FOR UBUNTU 
#Infection#6389
# Va dau valoare saracilor 
if [ $# != 1 ]; then
        echo " usage: $0 <server public ip>"
        exit;
fi
IP=$1
sudo apt-get update && sudo apt-get upgrade -y 
sudo apt-get install nano wget curl -y
sudo apt-get install default-jre -y
sudo apt-get install lib32gcc1 -y
sudo apt-get install openjdk-15-jre -y
sudo apt-get install openjdk-16-jre -y
sudo apt-get install openjdk-17-jre -y
sudo apt-get install openjdk-18-jre -y
sudo apt-get install openjdk-19-jre -y
sudo apt-get install openjdk-20-jre -y
sudo apt-get install -y gnupg
sudo apt-get install -y apt-transport-https
sudo apt-get install python3 python2 python python3-pip -y
sudo dpkg --add-architecture i386 
sudo apt-get update 
sudo apt-get install libc6:i386 -y
sudo apt-get install -y nginx
sudo apt-get install -y certbot python3-certbot-nginx

curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | sudo bash
apt-get install pufferpanel
systemctl enable pufferpanel
systemctl start pufferpanel

mkdir /etc/nginx/sites-enabled/
chmod +x /etc/nginx/sites-enabled/
touch /etc/nginx/sites-enabled/pufferpanel.conf 
echo -e "
server {
    listen 80;
     root /var/www/pufferpanel;

     server_name ${IP};

     location ~ ^/\.well-known {
           root /var/www/html;
           allow all;
     }

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Nginx-Proxy true;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        client_max_body_size 100M;
    }
}
" > /etc/nginx/sites-enabled/pufferpanel.conf


systemctl enable nginx
systemctl start nginx

systemctl restart nginx
certbot --nginx -d $1

sudo pufferpanel user add

echp "======================================================"
echp "                 YOUR PANEL IP IS http://${IP}        "
echp "======================================================"

