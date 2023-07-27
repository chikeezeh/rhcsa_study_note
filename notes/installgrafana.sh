#!/bin/bash
# This script will be used to automate the installation of Prometheus and Grafana on a RHEL based system
# This script won't work on other distributions of Linux
# Author: Chike Ezeh (ezeh.chike@gmail.com)

# first check if the user is root or running the script as sudo
if [ $UID -ne 0 ];
then
echo "Please run this script as root  or use sudo $0"
fi

####################
# Helper functions #
####################
function createdir(){
    if [[ -d $1 ]];
    then
        echo "$1 directory exists...changing ownership"
        chown $userprom:$userprom $1
    else
        echo "Creating $1 directory..."
        mkdir $1
        echo "Directory created...changing ownership"
        chown $userprom:$userprom $1
    fi
}


#####################################
# Dependencies and Pre-flight check #
#####################################
echo "Installing required packages"
yum update -y
yum install wget openssl -y
###########################
# Downloading Prometheus  #
###########################

if [ ! -f ./prometheus.tar.gz ];
then
echo "Downloading Prometheus"
wget https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz -O prometheus.tar.gz > /dev/null 2>&1
echo "Prometheus download completed"
else
echo "Prometheus archive file already downloaded."
fi

if [ ! -d ./prometheus ];
then
    mkdir ./prometheus
else
    rm -rf ./prometheus/*
fi
# extract the archive file.
echo "Extracting prometheus archive file"
tar -xvzf prometheus.tar.gz -C ./prometheus --strip-components=1 >/dev/null 2>&1

#clean up the downloaded archive file
rm -f ./prometheus.tar.gz > /dev/null 2>&1
if [ ! -f ./prometheus.tar.gz ];
then
echo "Clean up of downloads completed"
fi


#############################################
# Prometheus installation and configuration #
#############################################

# create a user for the prometheus package
echo
read -p "Please enter the user you want to use for prometheus: " userprom
if id "$userprom" &>/dev/null; 
then
    echo "User $userprom exists."
else
    echo "User $userprom does not exist."
    echo "Creating user: $userprom...."
    useradd --no-create-home --shell /bin/false $userprom
    if id "$userprom" &>/dev/null; 
    then
        echo "User:$userprom successfully created"
    fi
fi
# Create directories for prometheus configuration files
createdir "/etc/prometheus"
createdir "/var/lib/prometheus"
sleep 5
echo "Creating configuration files and directories...."
# copied the extracted prometheus file to the right locations
if [[ -f "/usr/local/bin/prometheus" ]];
then
chown $userprom:$userprom /usr/local/bin/prometheus
else
cp ./prometheus/prometheus /usr/local/bin && chown $userprom:$userprom /usr/local/bin/prometheus
fi

if [[ -f "/usr/local/bin/promtool" ]];
then
chown $userprom:$userprom /usr/local/bin/promtool
else
echo "copying required files and changing ownership..."
cp ./prometheus/promtool /usr/local/bin && chown $userprom:$userprom /usr/local/bin/promtool
fi

if [[ -d "/etc/prometheus/consoles" ]];
then
chown -R $userprom:$userprom /etc/prometheus/consoles
else
echo "copying required files and directories and changing ownership..."
cp -r ./prometheus/consoles /etc/prometheus/ && chown -R $userprom:$userprom /etc/prometheus/consoles
fi

if [[ -d "/etc/prometheus/console_libraries" ]];
then
chown -R $userprom:$userprom /etc/prometheus/console_libraries
else
cp -r ./prometheus/console_libraries /etc/prometheus/ && chown -R $userprom:$userprom /etc/prometheus/console_libraries
fi

#prometheus configuration file
promconfig="/etc/prometheus/prometheus.yml"
if [[ ! -f $promconfig ]];
then
touch $promconfig
fi
if grep 'global' $promconfig && grep 'targets' $promconfig;
then echo "$promconfig already edited"
else
cat <<EOF > $promconfig
global:
  scrape_interval: 10s
scrape_configs:
  - job_name: 'prometheus_monitor'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
EOF
fi


chown prometheus:prometheus /etc/prometheus/prometheus.yml

# prometheus systemd file
systemdprom="/etc/systemd/system/prometheus.service"
if [[ ! -f $systemdprom ]];
then
touch $systemdprom
fi

cat <<EOF > $systemdprom
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi.target
EOF
echo "Prometheus configuration files created..."
# start and enable prometheus service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus > /dev/null 2>&1

if systemctl is-active --quiet prometheus; then
    echo "prometheus service is running."
else
    echo "prometheus service is not running."
    exit
fi
#############################################
# Grafana installation and configuration    #
#############################################

# create grafana repo
function poprepo () {
cat <<EOF >$1
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt    
EOF
}
grafanarepo="/etc/yum.repos.d/grafana.repo"
if [[ ! -f $grafanarepo ]];
then
echo "Creating repo file for grafana"
touch $grafanarepo
poprepo $grafanarepo
else
poprepo $grafanarepo
fi

# install grafana repo
if rpm -qi grafana > /dev/null 2>&1; #check if grafana has been installed.
then
    echo "Grafana successfully installed"
else
    yum install grafana -y > /dev/null 2>&1
    if rpm -qi grafana > /dev/null 2>&1;
    then
    echo "Grafana successfully installed"
    fi
fi

# start grafana server
if systemctl is-active --quiet grafana-server;
then
    echo "Grafana Server is up and running"
else
    systemctl start grafana-server > /dev/null 2>&1
    systemctl enable grafana-server > /dev/null 2>&1
    if systemctl is-active --quiet grafana-server;
    then
        echo "Grafana server is up and running"
    else
        echo "Grafana server is not running...check error logs"
        exit
    fi

fi

# enable grafana via firewalld
if firewall-cmd --zone=public --query-port=3000/tcp > /dev/null 2>&1; then
    echo "Port 3000 is already open."
else
    echo "Opening port 3000/tcp"
    firewall-cmd --add-port=3000/tcp --permanent --zone=public > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    if firewall-cmd --zone=public --query-port=3000/tcp > /dev/null 2>&1; then
    echo "Port 3000 is opened."
    fi
fi

# # reset admin password
# echo
# while true; do
#     read -s -p "Please enter the password you want to use for grafana admin: " new_password
#     echo
#     read -s -p "Please re-enter the password you want to use for grafana admin: " new_password2
#     echo
#     [ "$new_password" = "$new_password2" ] && break
#     echo "Please try again"
# done

# # Use Grafana CLI to reset the admin password
# grafana-cli admin reset-admin-password "$new_password" > /dev/null 2>&1

#############################################
# Install Nginx to act as a reverse proxy   #
#############################################

if rpm -qi nginx > /dev/null 2>&1;
then
    echo "Nginx already installed"
else
    echo "Installing Nginx..."
    yum install nginx -y > /dev/null 2>&1
    if rpm -qi nginx > /dev/null 2>&1;
    then
        echo "Nginx succesfully installed"
    else
        echo "Nginx not installed"
    fi
fi

# start nginx service
if systemctl is-active --quiet nginx;
then
    echo "nginx service is up and running"
else
    systemctl start nginx > /dev/null 2>&1
    systemctl enable nginx > /dev/null 2>&1
    if systemctl is-active --quiet nginx;
    then
        echo "nginx service is up and running"
    else
        echo "nginx service is not running...check error logs"
        exit
    fi

fi

# enable nginx via firewalld
function enablefirewall (){
if firewall-cmd --zone=public --query-service=$1 > /dev/null 2>&1; then
    echo "$1 enabled through Firewall"
else
    echo "Enabling $1 through firewall"
    firewall-cmd --add-service=$1 --permanent --zone=public > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    if firewall-cmd --zone=public --query-service=$1 > /dev/null 2>&1; then
    echo "$1 enabled through Firewall"
    fi
fi
}
enablefirewall http
enablefirewall https

#Make a directory to contain your grafana website config, 
if [[ -d /etc/nginx/sites-enabled ]];
then
    echo "/etc/nginx/sites-enabled already exists"
else
    mkdir /etc/nginx/sites-enabled
fi
# add include /etc/nginx/sites-enabled/* to the http section of the nginx.conf file
if grep '/etc/nginx/sites-enabled/' /etc/nginx/nginx.conf > /dev/null 2>&1;
then
echo "/etc/nginx/nginx.conf edited"
else
sed -i '\t/include \/etc\/nginx\/conf.d\/\*.conf;/a\include \/etc\/nginx\/sites-enabled\/\*;' /etc/nginx/nginx.conf
fi

# create grafana website configuration
grafanawebconfig="/etc/nginx/sites-enabled/$HOSTNAME.conf"
if [[ -f $grafanawebconfig ]];
then
echo "$grafanawebconfig already exists"
else
touch $grafanawebconfig
fi

# create self signed certificate to be used for https
if [ -f "/etc/nginx/self-signed.key" ] && [ -f "/etc/nginx/self-signed.crt" ];
then
echo "self signed certificates already created"
else
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/self-signed.key -out /etc/nginx/self-signed.crt
echo "self signed certificates created"
fi

# update the grafana website config page to include the self signed certificate
# and redirect http to https
ipaddr=$(hostname -I | awk '{$1=$1;print}') #get the IP addr
cat <<EOF > $grafanawebconfig
server {
    listen 443 ssl;
    server_name  "$ipaddr";
    ssl_certificate /etc/nginx/self-signed.crt;
    ssl_certificate_key /etc/nginx/self-signed.key;

    location / {
        proxy_set_header Host \$http_host;
        proxy_pass  "http://$ipaddr:3000/";
    }

}
server {
    listen 80;
    server_name "$ipaddr";

    # Redirect HTTP to HTTPS
    return 301 https://\$host\$request_uri;
}
EOF
# check if nginx is configured properly
if nginx -t;
then
echo "Nginx configuration is looking good"
systemctl restart nginx > /dev/null 2>&1
    if systemctl is-active --quiet nginx;
    then
        echo "nginx service is up and running"
    else
        echo "nginx service is not running...check error logs"
        exit
    fi
else
echo "There is a problem with Nginx server configuration"
fi
# set the SELinux policy for our Nginx webserver
setsebool -P httpd_can_network_connect on

###########################################
# Node exporter install and configuration #
###########################################

read -p "Please enter the IP address you will like to monitor" remoteip
read -p "Enter a unique name for your server" servername
#ssh into the remote server and execute the installnode script
ssh root@$remoteip 'bash -s' < ./installnode

# edit the prometheus config file to add the new server to be monitored

if grep $remoteip $promconfig;
then
echo "$remoteip already added to Prometheus config file"
else
echo "adding $remoteip to prometheus config file"
cat <<EOF >> $promconfig
  - job_name: '$servername'
    scrape_interval: 5s
    static_configs:
      - targets: ['$remoteip:9100']
EOF
fi

systemctl restart prometheus
if systemctl is-active --quiet prometheus; then
    echo "prometheus service is running."
else
    echo "prometheus service is not running."
    exit
fi


