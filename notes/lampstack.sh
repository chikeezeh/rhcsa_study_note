#!/bin/bash
# This script will be used to automatically install a Wordpress website running on the
# LAMP stack, where the Linux OS is a RHEL based OS, this script won't work on other
# distributions of Linux.
# Author: Chike Ezeh 

# The tasks in this script requires sudo privilege
if [ $UID -ne 0 ];
then
    echo "Please run this script as root user, or use the sudo $0 command"
    exit
fi
# function to clean up the installation if exit signal is received before the script
# is done executing
function rollback () {
    echo "Exit signal received performing clean up process"
    # stop all running service
    systemctl stop httpd > /dev/null 2>&1
    systemctl stop mysqld > /dev/null 2>&1
    # remove http(s),mysql and port (80 and 443) service from firewall
    firewall-cmd --remove-service={http,https,mysql} > /dev/null 2>&1
    firewall-cmd --remove-port=80/tcp > /dev/null 2>&1
    firewall-cmd --remove-port=443/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    # delete any downloads
    rm -rf ./projects
    # delete all packages installed
    yum remove wget unzip -y > /dev/null 2>&1
    yum remove httpd -y > /dev/null 2>&1
    yum remove php php-curl php-bcmath php-gd php-soap php-zip php-curl php-mbstring php-mysqlnd php-gd php-xml php-intl php-zip -y > /dev/null 2>&1
    yum remove mysql mysql-server -y > /dev/null 2>&1 
    yum remove mod_ssl -y > /dev/null 2>&1
    # delete all configuration file and installation files
    rm -rf /var/www/html/* > /dev/null 2>&1
    rm -rf /var/lib/mysql* > /dev/null 2>&1
    rm -rf /etc/httpd/* > /dev/null 2>&1
    echo "Clean up completed"
    exit
}

trap rollback SIGINT SIGTERM SIGHUP SIGQUIT

# a function to check if a service is enabled through firewall, if it is not, then enable it.
function enablefirewall (){
    if firewall-cmd --list-services | grep -wq "$1"; then
    echo "The service $1 is enabled in Firewalld."
    else
    firewall-cmd --permanent --add-service=$1 --zone=public > /dev/null
    firewall-cmd --reload > /dev/null
    echo "The service $1 is enabled in Firewalld."
    fi
}

# a function to start a service, then verify if the service is started
function startservice (){
echo "Starting $1 service"
systemctl start $1 > /dev/null 2>&1
systemctl enable $1 > /dev/null 2>&1
sleep 5
echo ......
if systemctl is-active --quiet $1; then
    echo "$1 service is running."
else
    echo "$1 service is not running."
    exit
fi
}
##################################
# Downloads and Pre-flight check #
##################################

echo "Installing required packages, please wait ...."
# Installation of packages that can be obtained from official repositories
yum update -y > /dev/null 2>&1
yum install wget unzip -y > /dev/null 2>&1 # prerequisite packages
yum install httpd -y > /dev/null 2>&1 #apache
yum install php php-curl php-bcmath php-gd php-soap php-zip php-curl php-mbstring php-mysqlnd php-gd php-xml php-intl php-zip -y > /dev/null 2>&1 # php packages needed
yum install mysql mysql-server -y > /dev/null 2>&1 # install mysql server and mysql client
echo "Done installing packages from official repository"

# Downloading and installing wordpress in the required directory
if [ ! -d ./projects ];
then
    mkdir ./projects
fi
echo "Downloading the latest version of Wordpress"
wget -P ./projects https://wordpress.org/latest.zip > /dev/null 2>&1
if [ -f ./projects/latest.zip ]; # check if download was completed
then
    echo "Wordpress successfully downloaded"
else
    echo "Wordpress wasn't downloaded, please check the url"
    exit
fi
echo "Unzipping the downloaded wordpress to /var/www/html"
sleep 5
echo "........."
unzip ./projects/latest.zip -d /var/www/html/ > /dev/null 2>&1
echo "Wordpress unzipped to /var/www/html/ directory"
sleep 5
echo "cleaning up downloads...."
rm -rf ./projects
sleep 5
echo "clean up completed."
sleep 5
echo "Moving the content of the /var/www/html/wordpress to the /var/www/html/ directory"
echo "........."
mv /var/www/html/wordpress/* /var/www/html/
echo "files move completed."

chown -R apache:apache /var/www/html/* #change the ownership to apache
chcon -t httpd_sys_rw_content_t /var/www/html -R #change the SELinux context of the directory containing the wordpress website
setsebool -P httpd_can_network_connect true # SELinux setting to allow our wordpress website talk to wordpress plugins website

#######################
# Mysql Configuration #
#######################

startservice mysqld
enablefirewall mysql

echo "Securing the MySQL installation"
# Secure the Mysql configuration
# Check if the root password is not set then set it
if mysql -u root -e 'quit' > /dev/null 2>&1;
then
mysql_secure_installation
fi
echo "MySQL installation secured"
# keep asking the user for the correct MySQL root password
while true; do
    read -s -p "Enter the root password for MySQL " password
    echo
    mysql -u root -p$password -e 'quit'> /dev/null 2>&1 #check if we can log into the mysql shell with the root password
    if [ $? -eq 0 ];
    then
        echo "Correct root password entered"
        break
    else
        echo "Incorrect root password entered, try again"
    fi
done

read -p "Please enter the user for the wordpress database " dbuser
while true; do
    read -s -p "Please enter the password you want to use for the $dbuser " dbpasswd
    echo
    read -s -p "Please re-enter the password you want to use for the $dbuser " dbpasswd2
    echo
    [ "$dbpasswd" = "$dbpasswd2" ] && break
    echo "Please try again"
done
echo
read -p "Please enter the database name " dbname
echo "Configuring database for Wordpress"
sleep 5
mysql -u root -p$password <<EOF >/dev/null 2>&1
CREATE DATABASE $dbname;
CREATE USER '$dbuser'@'localhost' IDENTIFIED BY "$dbpasswd";
GRANT ALL on $dbname.* TO '$dbuser'@'localhost';
EOF
echo "Database configured, database name:$dbname, database user: $dbuser"
########################
# Apache configuration #
########################

# starting the service and enabling through firewall
startservice httpd
enablefirewall http
enablefirewall https

# open port 80 and 443
echo "Opening ports 80 and 443"
firewall-cmd --add-port=80/tcp --add-port=443/tcp --permanent > /dev/null 2>&1
firewall-cmd --reload 
sleep 5
echo "Ports 80 and 443 opened"
sleep 5
echo "Creating self-signed certificate for https"
# Configuring apache to be served via https
yum install mod_ssl openssh -y > /dev/null 2>&1 #install ssl module needed for self signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/tls/private/apache.key -out /etc/pki/tls/certs/apache.crt #creating self signed certificate
ipaddr=$(hostname -I) #get the IP addr

# create the Apache configuration file to use the ssl certificate created
# and redirect http to https

cat <<EOF > /etc/httpd/conf.d/wordpress.conf
<VirtualHost *:443>
    ServerName https://$ipaddr
    DocumentRoot /var/www/html
    SSLEngine on
    SSLCertificateFile /etc/pki/tls/certs/apache.crt
    SSLCertificateKeyFile /etc/pki/tls/private/apache.key
</VirtualHost>

<VirtualHost *:80>
    ServerName $ipaddr
    Redirect permanent / https://$ipaddr
</VirtualHost>
EOF
echo "Self-signed certificate sucessfully created"
# reload apache
systemctl restart httpd

# verify httpd status
if systemctl is-active --quiet httpd; then
    echo "httpd service is running."
else
    echo "httpd service is not running."
    exit
fi

###################################################
# Wordpress configuration and admin account setup #
###################################################

# configure Wordpress by adding the database information to the wp-config.php file
wp_config=/var/www/html/wp-config.php
cp /var/www/html/wp-config-sample.php $wp_config
chown apache:apache $wp_config
sed -i "s/database_name_here/$dbname/" $wp_config
sed -i "s/username_here/$dbuser/" $wp_config
sed -i "s/password_here/$dbpasswd/" $wp_config

# Use WP-CLI to configure the WP admin account
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null 2>&1 # download WP-CLI
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp

# Get website and admin information
wp_url="https://$ipaddr"
read -p "Please enter the Website Title: " wp_title
read -p "Please enter the Wordpress admin username: " wp_admin_user
stty -echo
while true; do
    read -s -p "Please enter the password you want to use for the Wordpress admin:$wp_admin_user: " wp_admin_password
    echo
    read -s -p "Please re-enter the password you want to use for the Wordpress admin:$wp_admin_user: " wp_admin_password2
    echo
    [ "$wp_admin_password" = "$wp_admin_password2" ] && break
    echo "Please try again"
done
stty echo
echo
read -p "Please enter the admin email: " wp_admin_email
cd /var/www/html || exit
wp core install --url="$wp_url" --title="$wp_title" --admin_user="$wp_admin_user" --admin_password="$wp_admin_password" --admin_email="$wp_admin_email" > /dev/null 2>&1
echo "Your Wordpress website is ready to use, go to https://$ipaddr"


























