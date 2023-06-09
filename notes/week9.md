### Week nine study note (6/04/2023 - 6/10/2023)<!-- omit from toc -->

#### Tracing Network Traffic
The `traceroute` is used to map the journey that a packet of data takes from its origin to its destination, `traceroute` is used when troubleshooting network issues, it can be used to determine where a packet is dropping in the network, this can help to tell us if a node is down in the network.
```console
traceroute google.com
traceroute to google.com (172.217.14.110), 30 hops max, 60 byte packets
 1  _gateway (192.168.18.2)  0.456 ms  0.368 ms  0.339 ms
 2  * * *
 3  * * *
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *

```
#### Configure and Secure SSH
`ssh` &rarr; secure shell, a shell provides an interface to the Linux system. It takes the commands we type in and translate them to kernel to manage hardware.
Package for ssh &rarr; Open SSH
Service daemon &rarr; sshd
Default port &rarr; 22

##### Securing SSH
Week 8 has some tips on securing ssh by editing the `/etc/ssh/sshd_config` file. In addition, the following should be done also:
1. Set time out interval: `ClientAliveInterval 600` and `ClientAliveCountMax 0` this sets the time out to 600 secs.
2. Disable empty passwords, users with empty passwords can't log into the system via ssh. `PermitEmptyPasswords no`
3. Limit ssh access to specific users. `AllowUsers user1 user2`

##### Passwordless ssh login
This is used when there is frequent login via ssh to a remote machine, also it is useful when performing automation from one server to another. The steps to create passwordless ssh login is as follows.
1. Generate a private/public key pair on the local machine. `ssh-keygen`
2. Copy the public key to the remote server. `ssh-copy-id user@ip_of_server`, this will ask you the password of the user on the remote server to verify that you have access to the machine.
3. Login from the local machine to the remote server using `ssh user@ip_of_server`, you should be logged into the remote server without being prompted for a password.

#### Firewall

A firewall is used to test the packet information of a data as it moves in and out of a server using the firewall rules. The rules will either allow or deny the movement of the data.
1. Software firewall &rarr; runs on the operating system,
2. Hardware firewall &rarr; dedicated appliance with a firewall software.

##### Tools for managing firewall
1. iptables &rarr; used on older Linux versions
2. firewalld &rarr; New version of Linux

