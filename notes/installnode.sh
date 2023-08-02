#!/bin/bash
# This script will be used to automate the installation of node_exporter  on a RHEL based system that will 
# be monitored using prometheus and grafana for dashboarding.
# This script won't work on other distributions of Linux
# Author: Chike Ezeh (ezeh.chike@gmail.com)
if rpm -qi wget > /dev/null 2>&1;
then
    echo "wget already installed"
else
    echo "Installing wget...."
    yum install wget -y > /dev/null 2>&1
    if rpm -qi wget > /dev/null 2>&1;
    then
        echo "wget installed"
    else
        exit
    fi
fi

if [ -f node_exporter.tar.gz ];
then
echo "Node_exporter archive file downloaded"
else
    echo "downloading Node Exporter"
    wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz -O node_exporter.tar.gz > /dev/null 2>&1
    sleep 5
    echo "Node exporter download completed"
fi
if [ ! -d ./node_exporter ];
then
    mkdir ./node_exporter
else
    rm -rf ./node_exporter/*
fi
tar -xvzf node_exporter.tar.gz -C ./node_exporter --strip-components=1

if [ -f "/usr/local/bin/node_exporter" ];
then
    echo "node_exporter moved"
else
    cp ./node_exporter/node_exporter /usr/local/bin/
fi

if id "nodeusr" &>/dev/null; 
then
    echo "User nodeusr exists."
else
    echo "User nodeusr does not exist."
    echo "Creating user: nodeusr...."
    useradd -rs /bin/false nodeusr
    if id "nodeusr" &>/dev/null; 
    then
        echo "User:"nodeusr" successfully created"
    fi
fi
chown nodeusr:nodeusr /usr/local/bin/node_exporter
cat <<EOF >/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload > /dev/null 2>&1
systemctl start node_exporter > /dev/null 2>&1
systemctl status node_exporter > /dev/null 2>&1
systemctl enable node_exporter > /dev/null 2>&1

if systemctl is-active --quiet node_exporter; then
    echo "node_exporter service is running."
else
    echo "node_exporter service is not running."
    exit
fi

# open the required port
if firewall-cmd --zone=public --query-port=9100/tcp > /dev/null 2>&1; then
    echo "Port 9100 is already open."
else
    echo "Opening port 9100/tcp"
    firewall-cmd --add-port=9100/tcp --permanent --zone=public > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    if firewall-cmd --zone=public --query-port=9100/tcp > /dev/null 2>&1; then
    echo "Port 9100 is opened."
    fi
fi