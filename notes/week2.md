### Week two study note (4/16/2023 - 4/22/2023)<!-- omit from toc -->

#### Pipe |
Pipe is used to redirect the output of one command as the input of another command. In the example below, we cat the file and count the number of lines.
```console
┌──[19:56:15]─[0]─[root@almanode1:~/scripts]
└──| cat filegen.sh | wc -l
15
```
### Networking

#### Network Components
* IP 
>Internet Protocol, unique string of numbers separated by `.` that identifies a machine in a network.
* Subnet Mask
>A subnet mask is a numerical code that is used to identify which part of an IP address is used to represent a network, and which part is used to represent a device on that network.
>
>Think of it like a street address. Just like how a street address has two parts (the name of the street, and the house or apartment number), an IP address also has two parts: the network portion and the host portion. The subnet mask is like the divider between these two parts.
>
>For example, let's say you have an IP address of 192.168.1.10 and a subnet mask of 255.255.255.0. The subnet mask tells your computer that the first three numbers (192.168.1) represent the network, and the last number (10) represents the specific device on that network.
>
>In other words, the subnet mask helps your computer know which other devices on the network it can communicate with directly, and which devices it needs to send data to through a router or other networking device.
* Gateway
>A gateway is a network device that connects different networks together, allowing them to communicate with each other. It acts as an entry and exit point for data traffic flowing between different networks.
* STATIC vs DHCP
>Static and DHCP are two different ways to assign IP addresses to devices on a network.
>
>Static IP addressing involves manually assigning a specific IP address to each device on the network. This means that each device will always use the same IP address every time it connects to the network. Static IP addressing is commonly used for servers, printers, and other devices that need a consistent and easily identifiable IP address. However, manually assigning IP addresses can be time-consuming and can lead to errors if IP addresses are not managed properly.
>
>Dynamic Host Configuration Protocol (DHCP) is a network protocol that automatically assigns IP addresses to devices as they connect to the network. When a device joins the network, it sends a request to a DHCP server, which responds with an available IP address for the device to use. This means that IP addresses are allocated dynamically, and devices can be easily added or removed from the network without having to manually configure their IP addresses.
>
>DHCP has several advantages over static IP addressing. It saves time and effort by automating the process of assigning IP addresses to devices, and reduces the risk of IP address conflicts that can occur when devices are manually assigned the same IP address. Additionally, DHCP allows for easier management of IP addresses and network resources.
>
>However, static IP addressing is still useful in certain situations, such as for devices that require a consistent IP address, or for networks that require a high level of control over IP address allocation.
>
>In summary, static IP addressing involves manually assigning a specific IP address to each device, while DHCP automatically assigns IP addresses to devices as they connect to the network. The choice between static and DHCP addressing depends on the specific needs of the network and the devices on it.

#### Network Files and Commands
##### Interface configuration files
* `/etc/nsswitch.conf` &rarr; his file controls the order in which the system searches for information such as hostnames, IP addresses, and user information. It specifies which sources to query for this information, such as DNS or the local`/etc/hosts` file.
* `/etc/hosts` &rarr; Defines local system IP address and hostname.
* `/etc/NetworkManager/system-connections/` &rarr; on newer RHEL distributions the interface configurations have been moved to keyfiles.
>```console
>┌──[05:38:27]─[0]─[root@almanode1:/etc/NetworkManager/system-connections]
>└──| cat ens33.nmconnection
>[connection]
>id=ens33
>uuid=3e7f4ce2-536f-38e2-973a-70416b59337b
>type=ethernet
>autoconnect-priority=-999
>interface-name=ens33
>timestamp=1679450545
>
>[ethernet]
>
>[ipv4]
>address1=192.168.18.130/24,192.168.18.2
>dns=8.8.8.8;
>method=manual
>
>[ipv6]
>addr-gen-mode=eui64
>method=auto
>
>[proxy]
>```
* `/etc/resolv.conf` &rarr; specifies dns server, resolves hostname to IP and IP to hostname.

#### Network Commands

* `ping` - This command is used to test network connectivity by sending ICMP echo request packets to a target host and receiving ICMP echo reply packets in response. It is often used to check if a host is reachable and to measure round-trip latency.

* `traceroute` - This command is used to trace the path that packets take from a source host to a destination host by sending ICMP packets with increasing TTL (Time-to-Live) values and recording the IP addresses of the routers along the way.

* `netstat` - This command is used to display various network-related information, such as active network connections, listening ports, and routing tables.

* `ifconfig/ip` - These commands are used to configure and display information about network interfaces on the system, such as IP addresses, netmasks, and network packets statistics.

* `nslookup/dig` - These commands are used to perform DNS lookups and query DNS servers for information about domain names, such as IP addresses and MX records.

* `tcpdump` works by capturing network packets that are either entering or leaving a network interface on the system. It can capture packets based on a variety of filters, such as source or destination IP address, protocol type, port number, and more.

#### Network Interface Card (NIC)
To get the information about your NIC, you run `ethtool interface_name`
```console
# Display the current settings for an interface:
ethtool eth0

# Display the driver information for an interface:
ethtool --driver eth0

# Display all supported features for an interface:
ethtool --show-features eth0

# Display the network usage statistics for an interface:
ethtool --statistics eth0

# Blink one or more LEDs on an interface for 10 seconds:
ethtool --identify eth0 10

# Set the link speed, duplex mode, and parameter auto-negotiation for a given interface:
ethtool -s eth0 speed 10|100|1000 duplex half|full autoneg on|off
source:cheat.sh
```
#### NIC Bonding
NIC bonding or Network bonding, is the combination of multiple NIC into a single bond interface.

##### Steps to create NIC bonding.
1. Use the following command to create a bond configuration file for the bond interface:
```console
sudo vi /etc/sysconfig/network-scripts/ifcfg-bond0

```
2. In the configuration file, set the following parameters:
```console
DEVICE=bond0
ONBOOT=yes
BOOTPROTO=none
IPADDR=<ip_address>
NETMASK=<subnet_mask>
GATEWAY=<gateway_address>
DNS1=<dns_server_1>
DNS2=<dns_server_2>
BONDING_OPTS="mode=<bonding_mode> miimon=<monitor_interval> xmit_hash_policy=<hashing_policy>"

```
Replace <ip_address> with the desired IP address, <subnet_mask> with the subnet mask for your network, <gateway_address> with the IP address of your default gateway, <dns_server_1> with the IP address of your primary DNS server, <dns_server_2> with the IP address of your secondary DNS server, <bonding_mode> with the desired bonding mode (e.g. active-backup, balance-rr, etc.), <monitor_interval> with the interval at which the bond driver sends a packet to verify link status, and <hashing_policy> with the desired packet distribution method.
3. Save and close the configuration file.
4. Use the following command to create configuration files for each network interface that will be included in the bond:
```console
sudo vi /etc/sysconfig/network-scripts/ifcfg-<interface_name>
```
Replace <interface_name> with the name of the interface, such as "eth0" or "enp0s3".
5. In each interface configuration file, set the following parameters:
```console
DEVICE=<interface_name>
ONBOOT=yes
BOOTPROTO=none
MASTER=bond0
SLAVE=yes
```
Replace <interface_name> with the name of the interface.
6. Save and close the configuration file.
7. Use the following command to restart the network service: `sudo systemctl restart network
`
8. `ip addr show` to verify ythat the bonding interface is up and running.
