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

#### Using the curl command
``` console
# curl
# Transfers data from or to a server.
# Supports most protocols, including HTTP, FTP, and POP3.
# More information: <https://curl.se>.

# Download the contents of a URL to a file:
curl http://example.com --output path/to/file

# Download a file, saving the output under the filename indicated by the URL:
curl --remote-name http://example.com/filename

# Download a file, following location redirects, and automatically continuing (r                                                                  esuming) a previous file transfer and return an error on server error:
curl --fail --remote-name --location --continue-at - http://example.com/filename

# Send form-encoded data (POST request of type `application/x-www-form-urlencode                                                                  d`). Use `--data @file_name` or `--data @'-'` to read from STDIN:
curl --data 'name=bob' http://example.com/form

# Send a request with an extra header, using a custom HTTP method:
curl --header 'X-My-Header: 123' --request PUT http://example.com

# Send data in JSON format, specifying the appropriate content-type header:
curl --data '{"name":"bob"}' --header 'Content-Type: application/json' http://ex                                                                  ample.com/users/1234

# Pass a username and password for server authentication:
curl --user myusername:mypassword http://example.com

# Pass client certificate and key for a resource, skipping certificate validatio                                                                  n:
curl --cert client.pem --key key.pem --insecure https://example.com

```
#### File Transfer Protocol (FTP)
FTP is a standard network protocol used for the transfer of computer files between a client and a server on a computer network, it uses the client-server model architecture using separate control and data connections between client and the server.

