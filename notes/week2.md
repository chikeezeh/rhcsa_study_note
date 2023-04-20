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
