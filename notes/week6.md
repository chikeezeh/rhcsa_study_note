### Week six study note (5/14/2023 - 5/20/2023)<!-- omit from toc -->
- [Network Time Protocol (NTP)](#network-time-protocol-ntp)
- [Chronyd](#chronyd)
- [timedatectl](#timedatectl)
  - [Examples](#examples)
- [Central Logger (RSYSLOG)](#central-logger-rsyslog)
- [Linux OS Hardening.](#linux-os-hardening)

#### Network Time Protocol (NTP)
This is used to synchronize the time on a machine to another server.
File &rarr; `/etc/ntp.conf`
Service &rarr; `systemctl restart ntpd`
Command &rarr; `ntpq`

#### Chronyd
This is a modern version of NTP that is also used for time synchronization.
Package name &rarr; `chronyd`
Configuration file &rarr; `/etc/chrony.conf`
Log file &rarr; `/var/log/chrony`
Service &rarr; `systemctl start chronyd`
Program commanc &rarr; `chronyc`

#### timedatectl
This is a replacement for the traditional `date` command, it can be used to show or change date, time, and timezone.
It can also be used for time synchronization with an NTP server.
##### Examples
```console
# Check the current system clock time:
timedatectl

# Set the local time of the system clock directly:
timedatectl set-time "yyyy-MM-dd hh:mm:ss"

# List available timezones:
timedatectl list-timezones

# Set the system timezone:
timedatectl set-timezone timezone

# Enable Network Time Protocol (NTP) synchronization:
timedatectl set-ntp on

# Change the hardware clock time standard to localtime:
timedatectl set-local-rtc 1

```
#### Central Logger (RSYSLOG)
This generates logs from other servers.
Service or package name &rarr; `rsyslog`
Config file &rarr; `/etc/ryslog.conf`
Service &rarr; `systemctl start rsyslog`

#### Linux OS Hardening.
1. User Account management
   1. Create less obvious username
   2. Set password expiry policies, the `chage` can be used for this.
2. Remove un-wanted packages
3. Stop un-used services
4. check on listening ports
5. secure SSH Configuration
6. Enable Firewall
7. Enable SELinux
8. Change Listening Services Port Numbers
9.  Keep your OS up to date.