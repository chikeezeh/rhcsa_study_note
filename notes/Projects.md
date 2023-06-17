### Using Prometheus and grafana to Monitor a Linux server.
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
