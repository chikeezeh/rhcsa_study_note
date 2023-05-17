### Week six study note (5/14/2023 - 5/20/2023)<!-- omit from toc -->

#### Network Time Protocol (NTP)
This is used to synchronize the time on a machine to another server.
File &rarr; `/etc/ntp.conf`
Service &rarr; `systemctl restart ntpd`
Command &rarr; `ntpq`

#### Chronyd
This is a modern version of NTP that is also used for time synchronization.
Package name &rarr; `chronyd`
Configuration file &rarr; `/etc/chronyd.conf`
Log file &rarr; `/var/log/chrony`
Service &rarr; `systemctl start chronyd`
Program commanc &rarr; `chronyc`