### Using Prometheus and grafana to Monitor a Linux server.<!-- omit from toc -->
- [Steps for installing prometheus on the monitoring server.](#steps-for-installing-prometheus-on-the-monitoring-server)
- [Steps for installing Node Exporter on the monitored server.](#steps-for-installing-node-exporter-on-the-monitored-server)
- [Steps for using the prometheus server to monitor the client server.](#steps-for-using-the-prometheus-server-to-monitor-the-client-server)
- [Install and configure Grafana on the monitoring server](#install-and-configure-grafana-on-the-monitoring-server)

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

