### Week three study note (4/23/2023 - 4/29/2023)<!-- omit from toc -->

#### Network Utilities
##### NetworkManager
This is a service that provides a set of tools designed specifically to make it easier to manage the networking configuration on Linux systems and is the default network management service on RHEL8 and RHEL9.
NetworkManager offers management through different tools.
* GUI
* nmtui
* nmcli

###### nmtui
Typing in the `nmtui` command gives you a menu interface that you can move around using the arrow keys to make selection as shown below.
![nmtui interface](../images/nmtui.jpg)
###### nmcli
You can use `nmcli` for various network related commands.
Showing the difference interfaces.
```console
[flatplanet@almanode1 ~]$ nmcli conn
NAME       UUID                                  TYPE      DEVICE  
alma_team  752dae25-64a8-402e-bbe9-8f1f0194bdac  team      nm-team 
ens33      66cb93ff-2bdb-4ff9-b9c8-d1fafeee6ca3  ethernet  ens33   
ens36      25a3e55a-1658-4558-85c7-b3a38ff5baf0  ethernet  ens36
```
Setting a static IP address.
```console
┌──[05:19:44]─[0]─[root@almanode1:~]
└──| nmcli connection modify ens33 ipv4.addresses 192.168.18.130/24
┌──[05:21:24]─[0]─[root@almanode1:~]
└──| nmcli connection modify ens33 ipv4.gateway 192.168.18.1
┌──[05:22:40]─[0]─[root@almanode1:~]
└──| nmcli connection modify ens33 ipv4.method manual
┌──[05:23:25]─[0]─[root@almanode1:~]
└──| nmcli connection modify ens33 ipv4.dns 8.8.8.8
┌──[05:23:56]─[0]─[root@almanode1:~]
└──| nmcli connection down ens33
┌──[05:23:56]─[0]─[root@almanode1:~]
└──| nmcli connection up ens33

```
#### Downloading Files or apps
We can use the `wget` command to download files from a server using the url.
