## Several Linux projects <!-- omit from toc -->

- [Using Prometheus, Node Exporter, and grafana to Monitor a Linux server.](#using-prometheus-node-exporter-and-grafana-to-monitor-a-linux-server)
  - [Steps for installing prometheus on the monitoring server.](#steps-for-installing-prometheus-on-the-monitoring-server)
  - [Steps for installing Node Exporter on the monitored server.](#steps-for-installing-node-exporter-on-the-monitored-server)
  - [Steps for using the prometheus server to monitor the client server.](#steps-for-using-the-prometheus-server-to-monitor-the-client-server)
  - [Install and configure Grafana on the monitoring server](#install-and-configure-grafana-on-the-monitoring-server)
  - [Reverse proxy and https](#reverse-proxy-and-https)
- [Using Nagios core, Nagios Plugins, and Nagios Remote Plugin Executor (NRPE) to monitor a Linux server.](#using-nagios-core-nagios-plugins-and-nagios-remote-plugin-executor-nrpe-to-monitor-a-linux-server)
  - [Installing Nagios Core from source on the monitoring server.](#installing-nagios-core-from-source-on-the-monitoring-server)
  - [Installing Nagios Plugin on the Nagios server.](#installing-nagios-plugin-on-the-nagios-server)
  - [Installing Nagios Plugins and NRPE On Remote Linux Host](#installing-nagios-plugins-and-nrpe-on-remote-linux-host)
  - [Install NRPE on Nagios Monitoring server.](#install-nrpe-on-nagios-monitoring-server)
  - [Configuring the Nagios monitoring server to monitor the remote Linux machines.](#configuring-the-nagios-monitoring-server-to-monitor-the-remote-linux-machines)
- [Configuring a package repository on Linux server.](#configuring-a-package-repository-on-linux-server)
  - [Initial Requirement.](#initial-requirement)
  - [Steps to take to configure the local repository](#steps-to-take-to-configure-the-local-repository)
- [Sample Bash script for system administration.](#sample-bash-script-for-system-administration)
  - [Bash script to check if user is locked and unlock the user.](#bash-script-to-check-if-user-is-locked-and-unlock-the-user)
  - [Bash script to check if user is locked and unlock the user with the added capability of sending logs to a file.](#bash-script-to-check-if-user-is-locked-and-unlock-the-user-with-the-added-capability-of-sending-logs-to-a-file)
  - [Bash Script to create usernames from a file containing first and last name](#bash-script-to-create-usernames-from-a-file-containing-first-and-last-name)
    - [Script requirement.](#script-requirement)
### Using Prometheus, Node Exporter, and grafana to Monitor a Linux server.
Two servers are needed for this project.
#### Steps for installing prometheus on the monitoring server.
1. Server 1 with hostname `lab05-prometheus.cezeh.dev` will be used to monitor server 2 the client server `lab05-client.cezeh.dev`. Both Linux servers will be running AlmaLinux 9
2. Create the two servers and update them as necessary, you can use this opportunity to set the hostnames using `hostnamectl set-hostname <your-FQDN>`
3. Go to the prometheus [website](https://prometheus.io/download/), right click on the most stable version for Linux OS and copy the link address.
4. Using the following command `wget https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz` download the tar file from the step above. You might need to install wget if your system doesn't have it.
5. Extract the downloaded tar file `tar -xvzf prometheus-2.44.0.linux-amd64.tar.gz`
6. Create a user with no shell and home page that the prometheus application will use.
   `useradd --no-create-home --shell /bin/false prometheus`
7. We need to create several directories to store our configuration files for prometheus, and change the ownership to the prometheus user created above.
 ```console
 mkdir /etc/prometheus && chown prometheus:prometheus /etc/prometheus
 mkdir /var/lib/prometheus && chown prometheus:prometheus /var/lib/prometheus
 ```
8. Navigate into the extracted folder from step 5 above `cd prometheus-2.44.0.linux-amd64`
9. We will need to copy the binaries in the `prometheus` and `promtool` files into the `/usr/local/bin`folder and make changes to the ownership.
```console
cp prometheus /usr/local/bin && chown prometheus:prometheus /usr/local/bin/prometheus
cp promtool /usr/local/bin && chown prometheus:prometheus /usr/local/bin/promtool
``` 
10. Also, copy the `consoles` and `console_libraries` to the configuration folder and change the ownership.
```console
cp -r consoles /etc/prometheus/ && chown -R prometheus:prometheus /etc/prometheus/consoles
cp -r console_libraries /etc/prometheus/ && chown -R prometheus:prometheus /etc/prometheus/console_libraries
```
11. Configure the prometheus server to monitor itself, we will makes changes to this file later when we want to monitor the client machine. `vi /etc/prometheus/prometheus.yml`
```vim
global:
  scrape_interval: 10s
  scrape_configs:
  - job_name: 'prometheus_monitor'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

```
12. Change the ownership of the configuration file from the step above. `chown prometheus:prometheus /etc/prometheus/prometheus.yml`
13. Configure the systemd file for prometheus so we can start it as a service.`vi /etc/systemd/system/prometheus.service`
```vim
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

```
14. Start the prometheus service by doing the following commands below.
```console
systemctl daemon-reload
systemctl start prometheus
systemctl status prometheus
systemctl enable prometheus
```
15. To access your prometheus web console, go to `http://<your_ip>:9090`, if all the configuration is done correctly, you should see an interface like the image below.
![prometheus](../images/prometheus.jpg)

#### Steps for installing Node Exporter on the monitored server.
To monitor a client server using prometheus, we will need to install and configure Node Exporter on the client server. The steps for doing that is outlined below.
1. Navigate to the download [page](https://prometheus.io/download/) of prometheus, then look for the latest stable version of node exporter.
2. Use wget to download the tar file, ` wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz`
3. Create a node exporter user, `useradd -rs /bin/false nodeusr`
4. Extract the downloaded node exporter tar file, `tar xvzf node_exporter-1.6.0.linux-amd64.tar.gz`
5. Navigate into the folder created from the step above, `cd node_exporter-1.6.0.linux-amd64`
6. Move the node_exporter file to the binaries location, `mv node_exporter /usr/local/bin`
7. Change the ownership of the binaries copied in the above step, `chown nodeusr:nodeusr /usr/local/bin/node_exporter`
8. Create the systemd file for node_exporter, `vim /etc/systemd/system/node_exporter.service`, enter the following entries below
```vim
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
```
9. Start the node_exporter service;

```console
systemctl daemon-reload
systemctl start node_exporter
systemctl status node_exporter
systemctl enable node_exporter
```
10. Enable node_exporter through firewall.

```console
firewall-cmd --add-port=9100/tcp --zone=public --permanent
firewall-cmd --reload
```
11. Go to this endpoint `http://<your_ip>:9100/metrics` if everything is configured correctly you should see the image below showing some system parameters. The endpoint can then be configured in the prometheus server to pull data from the client server.

![node_exporter](../images/node_exporter.jpg)

#### Steps for using the prometheus server to monitor the client server.
At this step, we should have a monitoring server with prometheus installed and configured. Also, we should have a client server with node exporter running. We can use the steps below to combine both machines, and monitor the client machine using the prometheus machine.
1. Edit the prometheus config file and add the values for the client server, `vim /etc/prometheus/prometheus.yml`
```vim
global:
  scrape_interval: 10s
scrape_configs:
  - job_name: 'prometheus_monitor'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'lab05-client'
    scrape_interval: 5s
    static_configs:
      - targets: ['<ip_address_of_client>:9100']
```
2. Restart the prometheus service, `systemctl restart prometheus`

3. Verify that the connection has been established by going to the following address, `http://monitoring_ip:9090/targets`, you should see the client machine and the prometheus machine showing up.

#### Install and configure Grafana on the monitoring server
Final step would be to install and configure grafana so we can create a dashboard quickly for different metrics we are interested in.
1. Create a grafana repo, `vim /etc/yum.repos.d/grafana.repo` and add the contents below.
```vim
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
```
2. Install grafana, `yum install grafana`
3. Verify that grafana was installed `rpm -qi grafana`
4. Start the grafana service

```console
systemctl start grafana-server
systemctl status grafana-server
systemctl enable grafana-server
```
5. Enable port 3000 through firewall `firewall-cmd --add-port=3000/tcp --permanent`
6. Reload firewall, `firewall-cmd --reload`
7. Go to `http:<ip>:3000` you should be welcomed with the grafana sign in page like below. The default username and passwd is admin admin, you will be prompted to change this password at first login.

![grafana](../images/grafana.jpg)

8. Once you are logged into grafana, look for data connections, search for prometheus, then add the prometheus end point (http://prometheus_ip:9090) to the Prometheus server url field.
![grafana_connections](../images/grafana_connections.jpg)
9. Next step is to create a dashboard with the new data connection, have fun experimenting!

#### Reverse proxy and https

1. Install nginx web server, `yum install nginx -y`
2. Start the web server, `systemctl start nginx`
3. Enable the web server at startup `systemctl enable nginx`
4. Enable http and https through firewall,`firewall-cmd --add-service={http,https} --permanent`
5. Reload the firewall `firewall-cmd --reload`
6. Make a directory to contain your grafana website config, `mkdir /etc/nginx/sites-enabled`
7. Open the global nginx configuration `vim /etc/nginx/nginx.conf`
8. Add this `include /etc/nginx/sites-enabled/*;` to the http section of the nginx.conf file, your http section of the configuration file should look like below:
```console

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }

```
9. Navigate to the folder we created earlier to contain grafana website configuration, `cd /etc/nginx/sites-enabled`
10. The file format is the fully qualified domain name.conf, `vim FQDN.conf`
11. Add the following content to the config file. We will create the self signed certificate in a separate step, however, if you change the name and location of your self signed certificate and key, change that in the config file. <span style="color:red">Replace <grafana_ip> with the IP address of your grafana server, for example; 10.24.25.1.</span>

```console
server {
    listen 443 ssl;
    server_name  <grafana_ip>;
    ssl_certificate /etc/nginx/self-signed.crt;
    ssl_certificate_key /etc/nginx/self-signed.key;

    location / {
        proxy_set_header Host $http_host;
        proxy_pass http://<grafana_ip>:3000/;
    }

}
server {
    listen 80;
    server_name <grafana_ip>;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}
```
12. Create ssl certificate and key using openssl, `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/self-signed.key -out /etc/nginx/self-signed.crt`
13. `nginx -t` to test nginx configuration
14. If no error, restart the nginx server,`systemctl restart nginx`

### Using Nagios core, Nagios Plugins, and Nagios Remote Plugin Executor (NRPE) to monitor a Linux server.

Two separate servers will be used for this project, one will be the Nagios host and the other will be a remote client that will be monitored by the Nagios host, both machines will be running AlmaLinux 9.

#### Installing Nagios Core from source on the monitoring server.

The Nagios [website](https://support.nagios.com/kb/article/nagios-core-installing-nagios-core-from-source-96.html#RHEL) has the steps for installing Nagios core on various Linux distributions, however we will need to make some modifications to be able to install it on AlmaLinux 9. The steps will be outlined below.

1. Update your new Linux server using `dnf update -y` and set the hostname to a FQDN `hostnameclt set-hostname FQDN`
2. Disable SELinux before proceeding (caution only do this on non-production server, or follow what your company policies are) `setenfore 0`, then edit the SELinux config file `vi /etc/selinux/config`, change `SELINUX=enforcing` to `SELINUX=permissive`.
3. Install the pre-requisite packages, 
   >`yum install -y gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix`
   `yum install openssl-devel`
4. Navigate to `/tmp`, `cd /tmp`
5. Download the latest version of Nagios core using wget; 
   `wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.13.tar.gz`
6. Extract the downloaded tar file.
    `tar xvzf nagios-4.4.13.tar.gz`
7. Navigate to the extracted folder `cd nagios-4.4.13`
8. Compile the Nagios code
   ```console
   ./configure
   make all
   ```
9. Create a `nagios` user and group, then modify the `apache` user to be added to the `nagios` group.
    ```console
    make install-group-users
    usermod -a -G nagios apache
    ```
10. Install the binaries, CGIs, and HTML files `make install`
11. Install and enable services
    ```console
      make install-daemoninit
      systemctl enable httpd
    ```
12. Install command mode `make install-commandmode`
13. Install configuration files `make install-config`
14. Install Apache Config `make install-webconf`
15. Configure firewall
    ```console
      firewall-cmd --zone=public --add-port=80/tcp --add-service={http,https} --permanent
      firewall-cmd --reload
    ```
16. Create a `nagiosadmin` user that will be used to log into the web interface, once you run the command below, you will be asked to enter in a password, that password will be used to log into the webinterface so remember it.
    `htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin`
17. Start your `httpd` and `nagios` service.
    ```console
    systemctl start httpd
    systemctl status httpd
    systemctl start nagios.service
    systemctl status nagios.service
    ```
18. If both services are running without any errors, navigate to the following url to access your Nagios web interface. `http://<nagios_server_ip>/nagios`, you will be greeted with a pop up to enter the username and password (nagiosadmin and the password we created earlier.)
19. Once you log in successfully, you should see a page like the image below.
![Nagios](../images/nagios.jpg)

20. We only have the Nagios core engine currently installed, so we won't be able to talk to any hosts including the server running Nagios. To be able to communicate with servers, we need to install Nagios pluggins.

#### Installing Nagios Plugin on the Nagios server.
1. Install the pre-requisite packages.
    ```console
    dnf install -y gcc glibc glibc-common openssl-devel perl wget gettext make net-snmp net-snmp-utils automake autoconf epel-release libpqxx-devel
    yum --enablerepo=epel install perl-Net-SNMP
    ```
2. Navigate into the /tmp directory `cd /tmp`
3. Use `wget` to download the source code for Nagios plugin, as at this writing the`2.4.4` version of the Nagios plugin throws an error of `ERROR: Could not determine OS. Please make sure lsb_release is installed`. We will use version `2.3.3` for this installation;
`wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz`
4. Extract the downloaded file; `tar zxf nagios-plugins.tar.gz`
5. Navigate to the extracted folder `cd /tmp/nagios-plugins-release-2.3.3`
6. Compile and Install the Nagios plugin
   ```console
   ./tools/setup
   ./configure
   make
   make install
   ```
7. Restart Nagios `systemctl restart nagios`
8. Test your Nagios by going to the web interface `http://<nagios_ip>/nagios`

#### Installing Nagios Plugins and NRPE On Remote Linux Host
To monitor a Linux machine with the Nagios server we configured earlier, we will need to install `Nagios Plugins` on the remote machine and also install `NRPE`. The remote Linux machine (also called client machine) doesn't need the Nagios core installed.
1. Install the pre-requisite packages
   ```console
   yum install -y gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel make automake autoconf net-snmp-utils epel-release net-tools
   yum --enablerepo=epel install perl-Net-SNMP -y
   ```
2. Create the user for Nagios, and set the password
   ```console
   useradd nagios
   passwd nagios
   ```
3. Download Nagios plugin
    ```console
    wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.3.3.tar.gz
    ```
4. Extract the downloaded file `tar xzvf nagios-plugins.tar.gz`
5. Navigate to the extracted directory `cd nagios-plugins-release-2.3.3`
6. Compile and install the Nagios plugin
    ```console
   ./tools/setup
   ./configure
   make
   make install
   ```
7. Change the ownership of the plugins directory to the Nagios user.
    ```console
    chown nagios.nagios /usr/local/nagios
    chown -R nagios.nagios /usr/local/nagios/libexec
    ```

#### Installing NRPE on the remote linux client.

1. Download NRPE plugin
    ```console
    wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.0.2/nrpe-4.0.2.tar.gz
    ```
2. Extract the downloaded file `tar xzvf nrpe-4.0.2.tar.gz`
3. Navigate to the extracted folder `cd nrpe-4.0.2`
4. Compile and install NPRE
    ```console
    ./configure --disable-ssl
    make all
    make install-plugin
    make install-daemon
    make install-config
    make install-init
    ```
5. Configure NRPE config file to add the Nagios server ip (note, this is the ip of the Linux server running Nagios core)
    ` vim /usr/local/nagios/etc/nrpe.cfg `
  Edit the part that says `allowed_hosts=127.0.0.1,::1` to `allowed_hosts=127.0.0.1,<ip_nagios_server>`, replace `<ip_nagios_server>` with actual IP of the machine running Nagios Core
6. Start the nrpe service
   ```console
   systemctl start nrpe
   systemctl status nrpe
   systemctl enable nrpe
   ``` 
7. Enable nrpe port 5666 through firewall
    ```console
    firewall-cmd --zone=public --add-port=5666/tcp --permanent
    firewall-cmd --reload
    ```
8. Verify that NRPE daemon is working correctly under systemd, you should get the output below when the netstat command is ran.
    ```console
    # netstat -at | grep nrpe
      tcp        0      0 0.0.0.0:nrpe            0.0.0.0:*               LISTEN
      tcp6       0      0 [::]:nrpe               [::]:*                  LISTEN

    ```

#### Install NRPE on Nagios Monitoring server.
The final stage of this project is to go back to our Nagios monitoring server, where we have Nagios core installed, then install NRPE and configure it.
1. Follow the steps 1 to 4 outlined in [installing NRPE plugin on remote linux server.](#markdown-installing-NRPE-on-the-remote-linux-client.)
2. Test that your Nagios server can talk with the remote linux machine using the command below, replace `<remote_ip>` with the ip of your remote linux client.
    `/usr/local/nagios/libexec/check_nrpe -H <remote_linux_ip_address>`
    You should get the following string `NRPE v4.0.2` if both servers can communicate

#### Configuring the Nagios monitoring server to monitor the remote Linux machines.
1. Create `hosts` and `services` config files.
   ```console
   cd /usr/local/nagios/etc/
   touch hosts.cfg
   touch services.cfg
   ```
2. Let the overall nagios config file know about the two files created above. `vim /usr/local/nagios/etc/nagios.cfg` add the lines below into the file, this will go under the other cfg_file variables.
   ```vim
    cfg_file=/usr/local/nagios/etc/hosts.cfg
    cfg_file=/usr/local/nagios/etc/services.cfg

   ```
3. Edit the hosts config file `vim /usr/local/nagios/etc/hosts.cfg`
   Add the following content, change your hostname to your actual hostame and ip to the ip of the remote linux client.
```vim
## Default Linux Host Template ##
define host{
name                            linux-box               ; Name of this template
use                             generic-host            ; Inherit default values
check_period                    24x7
check_interval                  5
retry_interval                  1
max_check_attempts              10
check_command                   check-host-alive
notification_period             24x7
notification_interval           30
notification_options            d,r
contact_groups                  admins
register                        0                       ; DONT REGISTER THIS - ITS A TEMPLATE
}

## Default
define host{
use                             linux-box               ; Inherit default values from a template
host_name                       <hostname of remote client> ; The name we're giving to this server
alias                           AlmaLinux 9                ; A longer name for the server
address                         <add_ip_remote_client>            ; IP address of Remote Linux host
}
```
4. Edit the service config file `vim /usr/local/nagios/etc/services.cfg`
```vim
  define service{
        use                     generic-service
        host_name               <hostname of remote client>
        service_description     CPU Load
        check_command           check_nrpe!check_load
        }

  define service{
        use                     generic-service
        host_name               <hostname of remote client>
        service_description     Total Processes
        check_command           check_nrpe!check_total_procs
        }

  define service{
        use                     generic-service
        host_name               <hostname of remote client>
        service_description     Current Users
        check_command           check_nrpe!check_users
        }

  define service{
        use                     generic-service
        host_name               <hostname of remote client>
        service_description     SSH Monitoring
        check_command           check_nrpe!check_ssh
        }

  define service{
        use                     generic-service
        host_name               <hostname of remote client>
        service_description     FTP Monitoring
        check_command           check_nrpe!check_ftp
        }

```
5. Configure the NRPE command `vim /usr/local/nagios/etc/objects/commands.cfg`. Add the content below to the end of the file.
    ``` vim
    ###############################################################################
    # NRPE CHECK COMMAND
    #
    # Command to use NRPE to check remote host systems
    ###############################################################################

    define command{
        command_name check_nrpe
        command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
        }
    ```
6. Run configuration check to see if there are any errors;
   `# /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg`
   You should see the output below:
   ```console
      Total Warnings: 0
      Total Errors:   0

      Things look okay - No serious problems were detected during the pre-flight check
   ```
7. Restart your Nagios service, `systemctl restart nagios`
8. Congratulations, you can now monitor the remote server when you go to your web interface `http://<nagios-server-ip>/nagios`

### Configuring a package repository on Linux server.

#### Initial Requirement.
To configure a package repository on a Linux machine, the following information is require.
1. The location of the packages, could be on another linux machine, in which case we will be given a file address on that machine. Also, the location could be hosted on another machine as a webserver, in that case we will get a web URL. For this we will use the url (http://example.com/test)
2. The name of repository (test).

#### Steps to take to configure the local repository

1. Create a file in the `/etc/yum.repos.d` directory;
  `touch /etc/yum.repos.d/local.repo`
2. Edit the `/etc/yum.repos.d/local.repo` file using your favorite editor, and add the contents shown below;

    ```vim
    [test]
    name=test
    baseurl=http:example.com/test
    gpgcheck=0
    enabled=1
    ```
3. Verify that the new repo has been created by running `yum repolist all`. You should see the new repo among the other repos on the system. See example below:

```console
repo id                    repo name                                          status
appstream                  AlmaLinux 9 - AppStream                            enabled
appstream-debuginfo        AlmaLinux 9 - AppStream - Debug                    disabled
appstream-source           AlmaLinux 9 - AppStream - Source                   disabled
baseos                     AlmaLinux 9 - BaseOS                               enabled
baseos-debuginfo           AlmaLinux 9 - BaseOS - Debug                       disabled
baseos-source              AlmaLinux 9 - BaseOS - Source                      disabled
crb                        AlmaLinux 9 - CRB                                  disabled
crb-debuginfo              AlmaLinux 9 - CRB - Debug                          disabled
crb-source                 AlmaLinux 9 - CRB - Source                         disabled
epel                       Extra Packages for Enterprise Linux 9 - x86_64     enabled
epel-debuginfo             Extra Packages for Enterprise Linux 9 - x86_64 - D disabled
epel-source                Extra Packages for Enterprise Linux 9 - x86_64 - S disabled
epel-testing               Extra Packages for Enterprise Linux 9 - Testing -  disabled
epel-testing-debuginfo     Extra Packages for Enterprise Linux 9 - Testing -  disabled
epel-testing-source        Extra Packages for Enterprise Linux 9 - Testing -  disabled
extras                     AlmaLinux 9 - Extras                               enabled
extras-debuginfo           AlmaLinux 9 - Extras - Debug                       disabled
extras-source              AlmaLinux 9 - Extras - Source                      disabled
highavailability           AlmaLinux 9 - HighAvailability                     disabled
highavailability-debuginfo AlmaLinux 9 - HighAvailability - Debug             disabled
highavailability-source    AlmaLinux 9 - HighAvailability - Source            disabled
nfv                        AlmaLinux 9 - NFV                                  disabled
nfv-debuginfo              AlmaLinux 9 - NFV - Debug                          disabled
nfv-source                 AlmaLinux 9 - NFV - Source                         disabled
plus                       AlmaLinux 9 - Plus                                 disabled
plus-debuginfo             AlmaLinux 9 - Plus - Debug                         disabled
plus-source                AlmaLinux 9 - Plus - Source                        disabled
resilientstorage           AlmaLinux 9 - ResilientStorage                     disabled
resilientstorage-debuginfo AlmaLinux 9 - ResilientStorage - Debug             disabled
resilientstorage-source    AlmaLinux 9 - ResilientStorage - Source            disabled
rt                         AlmaLinux 9 - RT                                   disabled
rt-debuginfo               AlmaLinux 9 - RT - Debug                           disabled
rt-source                  AlmaLinux 9 - RT - Source                          disabled
sap                        AlmaLinux 9 - SAP                                  disabled
sap-debuginfo              AlmaLinux 9 - SAP - Debug                          disabled
sap-source                 AlmaLinux 9 - SAP - Source                         disabled
saphana                    AlmaLinux 9 - SAPHANA                              disabled
saphana-debuginfo          AlmaLinux 9 - SAPHANA - Debug                      disabled
saphana-source             AlmaLinux 9 - SAPHANA - Source                     disabled
test                       test                                               enabled

```

### Sample Bash script for system administration.

#### Bash script to check if user is locked and unlock the user.
This script intends to answer the following questions.
1. Create a script that will check if a user account is locked
2. Print the account username is locked.
3. Use any Linux command to unlock the user account
4. print user account has been successfully unlocked
5. Put logs of the activity into /var/log/unlock.log

```sh
#!/bin/bash

# script requires root privilege, check if the user has sudo access
if [ $UID -ne 0 ];
then
    echo "You need root access to run this script"
    exit
fi

# check if log file exist, if it doesn't create it

logfile="/var/log/unlock.log"
username=$1 #capture the 1st argument passed to the script

if [ -f $logfile ];
then
    echo "The log file exists" | tee -a $logfile
else
    touch $logfile
    echo "created log file: $logfile" | tee -a $logfile
fi

# check if the user enters a username
if [ $# -ne 1 ];
then
    echo "The script requires a username, check below for how to execute the script" | tee -a $logfile
    echo "Usage: $0 <username>" | tee -a $logfile
    exit
else
    # check if the username is a valid user on the system
    if id -u $username &>> $logfile;
    then
        echo "About to check if user $username is locked " | tee -a $logfile    
    else
        echo "The supplied username:$username doesn't exist on this machine...exiting" | tee -a $logfile
        exit
    fi
fi

# if a username is supplied and the user exist on the machine, we can check if the user is locked.
userstatus=$(passwd -S $username | awk '{print $2}') #we are extracting the second field of the passwd -S <username> command.

if [ $userstatus == LK ];
then 
    echo "User account:$username is locked out" | tee -a $logfile
    echo "Unlocking user account:$username" | tee -a $logfile
    usermod -U $username
    echo "User account:$username unlocked" | tee -a $logfile
else
    echo "User account is not locked...exiting" | tee -a $logfile
    exit
fi

```
#### Bash script to check if user is locked and unlock the user with the added capability of sending logs to a file.
```sh
#!/bin/bash

# script requires root privilege, check if the user has sudo access
if [ $UID -ne 0 ];
then
    echo "You need root access to run this script"
    exit
fi

# a function that takes in either a string or a file, adds timestamp to the string 
# or the firstline of the file, echos the output and sends to a logfile also.
log_timestamp() {
    local input=$1
    local current_timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    local log_line

    if [[ -f "$input" ]]; then
        # Argument is a file
        local first_line
        read -r first_line < "$input"
        log_line="$current_timestamp: $first_line"
    else
        # Argument is a string
        log_line="$current_timestamp: $input"
    fi

    echo "$log_line" | tee -a $logfile
}

# file to store each activity
logfile="/var/log/unlock-reset.log"

# check if log file is created
if [ -f $logfile ];
then
    log_timestamp "The log file exists"
else
    touch $logfile
    log_timestamp "created log file: $logfile"
fi

#Take in the username we want to check if it is locked
read -p 'Please enter username: ' username
log_timestamp "$username entered by $USER"

# check if the username is a valid user on the system, send both stdout and stderror to tempfile 
if id -u $username &>> ./tempfile;
then
    log_timestamp "$username found" 
    log_timestamp "./tempfile"
    rm -f ./tempfile
else
    log_timestamp "The supplied username:$username doesn't exist on this machine...exiting"
    log_timestamp "./tempfile"
    rm -f ./tempfile
    exit
fi

# if the user exist on the machine, we can check if the user is locked.
userstatus=$(passwd -S $username | awk '{print $2}') #we are extracting the second field of the passwd -S <username> command.

if [ $userstatus == "LK" ];
then 
    log_timestamp "The account $username is locked"
    prompt=true
    while $prompt; do
        read -p "Do you want to unlock account $username? yes/no " unlock_input
        case $unlock_input in
            yes|y|Y)
                log_timestamp "Unlocking user account:$username"
                usermod -U $username
                userstatus_post=$(passwd -S $username | awk '{print $2}') #check if user is unlocked
                if [ $userstatus_post != "LK" ];
                then
                    log_timestamp "the account is now unlocked and can successfully login"
                fi
                prompt=false
                ;;
            no|n|N)
                log_timestamp "Mission aborted" 
                prompt=false
                ;;
            *)
                echo "Invalid response, please enter yes or no"
                ;;
        esac
    done
else
    log_timestamp "User account is not locked...exiting"
    exit
fi
```
#### Bash Script to create usernames from a file containing first and last name
##### Script requirement.
1. Read a file containing first and last name per line, each line will get a username.
2. The username will be the 1st character of the first name joined to the all the characters of the last name and all will be in lowercase. `example: Ade Bayo will resolve to abayo`
3. The usernames must be unique, so when we have `Ade Bayo` and `Alex Bayo` which will both resolve to `abayo`, we will need to add a number suffix to the next occurence of `abayo` to give us `abayo1`.
4. Following from requirement 3, when more than two usernames will resolve to the same username, we will need to keep increasing the number suffix. `abayo abayo1 abayo2...abayo<n>`.
5. Each of the username should be saved to a new file.

```sh
#!/bin/bash
#function to extract the digits at the end of usernames
# when we determine the last digits we can increment it by one for a user with same username
# extract_last_digits "testuser123" will return 123
# extract_last_digits "testuser" will return 0
function extract_last_digits(){
    local digits=$(echo "$1" | grep -Eo '[0-9]+$')
    if [ -z $digits ]; #check if the result is empty meaning we don't have digits
    then
        digits=0
    fi
    echo "$digits"
}

# a function that for each username gets the maximum number,
# for example if you have a username testuser, and you already have the following usernames
# testuser
# testuser1
# testuser2
# the function will return 3 (max_number=2 + 1) which will can then use to create testuser3

function get_new_suffix (){
    local file="$1" # we will be passing a file that contains the output of the grep command to this function
    local max_number=0
    local new_suffix=1

    while IFS= read -r line
    do
        local num=$(extract_last_digits "$line")
        if (( num > max_number));
        then
            max_number=$num
        fi
    done < "$file"
    new_suffix=$((new_suffix + max_number))
    echo "$new_suffix"
}


# Open the file for reading
file="username.txt"
userprofile="existinguser.txt" #contains existing users
while IFS= read -r line
do
    # Get the number of names on each line
    numname=$(echo $line | wc -w)
    # check if less than 2 or more than 2
    if [ $numname -ne 2 ];
    then
    echo "Needs firstname lastname"
    continue # this won't be used.
    fi
    firstname="$(echo $line | cut -d ' ' -f 1)" #get the firstname
    lastname=$(echo $line | cut -d ' ' -f 2) #get the lastname
    firstname_character="${firstname:0:1}" #extract the first character of firstname
    username="${firstname_character,,}${lastname,,}" #concat firstcharacter with lastname, all lowercase
    echo "checking $username existence"
    # check if the username / derivative of the username exists in our list of usernames
    # the output of the grep command will be redirected to a tmp file which we can read to get the maximum number suffix
    grep -E "^${username}[0-9]*$" "$userprofile" > ./tmp

    # check if the tmp file is not empty
    if [ -s "./tmp" ];
    then
    echo "$username exist"
    cat ./tmp
    new_username_suffix=$(get_new_suffix ./tmp)
    username="$username$new_username_suffix" #update username with the new num suffix
    echo "Created a unique username: $username"
    echo $username >> $userprofile
    rm -f ./tmp
    else
    echo "Adding $username to the list of approved usernames"
    echo $username >> $userprofile
    rm -f ./tmp
    fi

done < "$file"

```