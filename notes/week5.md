### Week five study note (5/07/2023 - 5/13/2023)<!-- omit from toc -->

#### DNS = Domain Name System
* Purpose of DNS
Hostname to IP resolution &rarr; (A Record)
IP to Hostname &rarr; (PTR Record)
Hostname to Hostname &rarr; (CNAME Record)

* Files
    `/etc/named.conf` &rarr; main configuration file for DNS
    `/var/named` &rarr; a directory that contains all the zone files and server definition.
* Services
  The main service for using a Linux Machine as a DNS server is `named`.