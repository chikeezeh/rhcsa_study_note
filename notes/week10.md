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
* Prevent your machine from being pinged &rarr; `firewall-cmd --add-icmp-block-inversion`

#### Tune System Performance
`Tuned` is as `systemd` service that is used to optimize Linux system performance. It comes with predefined profiles and settings.

##### tuned profiles
`tuned-adm list #gives you a list of available profiles`
* `balanced` &rarr; deal for systems that require a compromise between power saving and performance.
* `desktop` &rarr; Derived from the balanced profile. Provides faster response of interactive applications.
* `Throughput-performance` &rarr; Tunes the system for maximum throughput
* `Latency-performance` &rarr; Ideal for server systems that require low latency at the expense of power consumption
* `network-latency` &rarr; Derived from the latency-performance profile. It enables additional network tuning parameters to provide low network latency
* `Network-throughput` &rarr; Derived from the throughput-performance profile. Additional network tuning parameters are applied for maximum network throughput
* `powersave` &rarr; Tunes the system for maximum power saving
* `oracle` &rarr; Optimized for Oracle database loads based on the throughput-performance profile.
* `virtual-guest` Tunes the system for maximum performance if it runs on a virtual machine.
* `virtual-host` Tunes the system for maximum performance if it acts as a host for virtual machines.

##### tuned commands
* `tuned-adm` &rarr; change setting for tuned daemon.
* `tuned-adm active` &rarr; check active profile.
* `tuned-adm profile profile-name` &rarr; change to a desired profile.
* `tuned-adm recommend` &rarr; tuned recommendation.
* `tuned-adm off` &rarr; turn off tuned setting daemon.
* 

