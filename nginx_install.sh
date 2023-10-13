#!/bin/bash

#update the package 
dnf update -y

#install nginx service
dnf install -y nginx

#disable selinux
setenforce 0
#create a directory
mkdir -p /var/www/html/

#create an index file in the /var/www/html
cat <<EOL > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to nginx!</title>
</head>
<body>
    <h1>Welcome to nginx test server !</h1>
</body>
</html>
EOL

# Configure server block in Nginx
cat <<Elk > /etc/nginx/conf.d/myserver.conf

server {
    listen 80;
    server_name abhiram-server;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    root /var/www/html;
    index index.html;
}


Elk

# Test Nginx configuration
nginx -t

#add ownership and change permission
sudo chmod -R 755 /var/www/html/
sudo chown -R nginx:nginx /var/www/html/


# Start and enable Nginx to start on boot
systemctl start nginx
systemctl enable nginx

#enable rule to firewall 
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent 
firewall-cmd --reload

echo "Nginx has been installed and configured successfully!"
