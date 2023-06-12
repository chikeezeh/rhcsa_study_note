### Week ten study note (6/11/2023 - 6/17/2023)<!-- omit from toc -->

#### Firewall Continued

##### Firewall commands
* Enable through systemd &rarr; `systemctl start firewalld && systemctl enable firewalld`
* Check rule &rarr; `firewall-cmd --list-all`
* List of predefined services &rarr; `firewall-cmd --get-services`
* Add a need service permanently &rarr;`firewall-cmd --add-service=name_of_service --permanent`
* Add a port to a specified zone &rarr; `firewall-cmd --permanent --zone=public --add-port=252/tcp`
* Remove a service &rarr; `firewall-cmd --remove-service=name_of_service --permanent`
* Reload firewall after changing configuration &rarr `firewall-cmd --reload`

* Reject traffic from an incoming address (rich rule) &rarr; `firewall-cmd --add-rich-rule='rule family="ipv4" source address="x.x.x.x" reject'`
* 