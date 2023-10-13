### Practice Questions and Answers<!-- omit from toc -->

1. Configure YUM repos with the given link ( 2 repos: 1st is BaseOS and 2nd is AppStream ) base_url= http://content.example.com/rhel8.0/x86_64/dvd/BaseOS AppStream_url= http://content.example.com/rhel8.0/x86_64/dvd/AppStream
```console
# create a file in /etc/yum.repos.d directory that ends in .repo
touch example.repo
vi example.repo
# add the content below
[BaseOS]
name=BaseOS
baseurl=http://content.example.com/rhel8.0/x86_64/dvd/BaseOS
enabled=1
gpgcheck=0

[AppStream]
name=AppStream
baseurl=http://content.example.com/rhel8.0/x86_64/dvd/AppStream
enabled=1
gpgcheck=0

```
2. A web server running on non standard port 82 is having issues serving content.
Debug and fix the issues.
The web server on your system can server all the existing HTML files from
/var/www/html
( NOTE: Do not make any changes to these files )
Web service should automatically start at boot time.
```console
# add the new port to selinux if log shows selinux is preventing httpd from starting
semanage port -a -t http_port_t -p tcp 82
# check the main configuration file of http is listening on port 82
vi /etc/httpd/conf/httpd.conf
```
3. Create a group named "manager"
Create a user sarah and harry should belong to the "manager" group as a secondary
group.
User natasha should have a non-interactive shell and he should not be a member of the
"manager" group. Add a rememberable password for all users.
```console
[root@rhcsa ~]# groupadd manager
[root@rhcsa ~]# useradd sarah
[root@rhcsa ~]# useradd harry
[root@rhcsa ~]# usermod -aG manager sarah
[root@rhcsa ~]# id sarah
uid=1001(sarah) gid=1002(sarah) groups=1002(sarah),1001(manager)
[root@rhcsa ~]# usermod -aG manager harry
[root@rhcsa ~]# id harry
uid=1002(harry) gid=1003(harry) groups=1003(harry),1001(manager)
[root@rhcsa ~]# useradd natasha -s /sbin/nologin
[root@rhcsa ~]# passwd sarah
Changing password for user sarah.
[root@rhcsa ~]# passwd harry
Changing password for user harry.
New password: 
[root@rhcsa ~]# su natasha
This account is currently not available.
[root@rhcsa ~]# su harry
[harry@rhcsa root]$ su sarah
Password: 
[sarah@rhcsa root]$
```
4. Create the Directory "/home/manager" with the following characteristics.
Group ownership of "/home/manager" should go to the "manager" group.
The directory should have full permission for all members of the "manager" group but
not to the other users except "root".
Files created in future under "/home/manager" should get the same group ownership .
```console
[root@rhcsa ~]# mkdir /home/manager
[root@rhcsa ~]# chown :manager /home/manager/
[root@rhcsa ~]# ll -d /home/manager
drwxr-xr-x. 2 root manager 6 Oct  7 19:30 /home/manager
[root@rhcsa manager]# chmod 2770 /home/manager
[root@rhcsa manager]# touch anoter
[root@rhcsa manager]# ll
-rw-r--r--. 1 root manager 0 Oct  7 19:34 anoter
```
5. Copy the file /etc/fstab to /var/tmp/ and configure the "ACL" as mentioned below.
><li>The file /var/tmp/fstab should be owned by the "root".
><li>The file /var/tmp/fstab should belong to the group "root".
><li>The file /var/tmp/fstab should not be executable by any one.
><li>The user "sarah" should be able to read and write to the file.
><li>The user "harry" can neither read nor write to the file.
><li>Other users (future and current) should be able to read /var/tmp/fstab
```console
# answer
[root@rhcsa tmp]# cp /etc/fstab /var/tmp/
[root@rhcsa tmp]# ll /var/tmp/fstab 
-rw-r--r--. 1 root root 653 Oct  8 08:19 /var/tmp/fstab
[root@rhcsa tmp]# setfacl -m u:sarah:rw /var/tmp/fstab 
[root@rhcsa tmp]# setfacl -m u:harry:--- /var/tmp/fstab 
[root@rhcsa tmp]# getfacl /var/tmp/fstab
getfacl: Removing leading '/' from absolute path names
# file: var/tmp/fstab
# owner: root
# group: root
user::rw-
user:sarah:rw-
user:harry:---
group::r--
mask::rw-
other::r--

[root@rhcsa tmp]# sudo -u harry cat /var/tmp/fstab
cat: /var/tmp/fstab: Permission denied
```
As seen above user harry can't read the `/var/tmp/fstab` file.

6. Configure a cron job that runs every 1 minutes and executes:
logger "EX200 in progress" as the user sarah.
```console
crontab -u sarah -e
# include the line below and save and quit the file.

* * * * * logger "EX200 in progress"

```
7. Create the user "julie" with uid 4332.
```console
[root@rhcsa ~]# useradd -u 4332 julie
[root@rhcsa ~]# id julie
uid=4332(julie) gid=4332(julie) groups=4332(julie)
```
8. locate the files of owner "julie" and copy to the location /root/found directory

```console
find / -user julie -type f -exec cp {} /root/found \;
```
9. Find the string "enter" from "/usr/share/dict/words" file and copy those lines in /root/strings file.
```console
[root@rhcsa ~]# cat /usr/share/dict/words 
 this is enter 1 
 this is enter 2 
 this is none
 this is another none none
 this is enter 3                 
[root@rhcsa ~]# cat /usr/share/dict/words | grep "enter" >> /root/strings
[root@rhcsa ~]# cat /root/strings
 this is enter 1 
 this is enter 2 
 this is enter 3
```
10. Synchronize time of your system with the server classroom.example.com

```console
# edit the /etc/chrony.conf file, and add the line server classroom.example.com iburst
to the file, comment out any configured ntp
```
```vim
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
# pool 2.rhel.pool.ntp.org iburst
server classroom.example.com iburst

```
11. Archive & compress for /etc directory under /var/tmp/archive.tar.bz2 format

```console
tar -cjf /var/tmp/archive.tar.bz2 /etc
```
12. Choose the recommended 'tuned' profile for your system and set it as the default.

```console
[root@rhcsa ~]# tuned-adm active
Current active profile: balanced
[root@rhcsa ~]# tuned-adm recommend
virtual-guest
[root@rhcsa ~]# tuned-adm profile virtual-guest
[root@rhcsa ~]# tuned-adm active
Current active profile: virtual-guest
```
13. Enable IP forwarding on your machine.

> First step is to find the parameter for IP forwarding.
> `sysctl -a | grep forward`
> The parameter to change is `net.ipv4.ip_forward = 0`.
> We have to append `net.ipv4.ip_forward=1` to the configuration file `/etc/sysctl.conf`. After that run the command `sysctl -p` to refresh the changes.


14. On your server, the httpd service has been configured to use NFS but the configuration will not work because of the SELinux policy. Fix this situation by enabling the "httpd_use_nfs" boolean and make persistent across reboot.

```console
# check the current state of the boolean
[root@rhcsa cezeh]# getsebool -a | grep httpd_use_nfs
httpd_use_nfs --> off
# set the boolean to on, then verify.
[root@rhcsa cezeh]# setsebool -P httpd_use_nfs on
[root@rhcsa cezeh]# getsebool -a | grep httpd_use_nfs
httpd_use_nfs --> on
```
15. System1 should boot into the multi-user target by default and boot messages should be present
(not silenced).
```console
# get the current target
[root@rhcsa ~]# systemctl get-default
graphical.target
# set the default target
[root@rhcsa ~]# systemctl set-default multi-user.target
Removed /etc/systemd/system/default.target.
Created symlink /etc/systemd/system/default.target → /usr/lib/systemd/system/multi-user.target.
# to make boot messages present, edit the /etc/default/grub file
# remove rhgb and quiet
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto resume=UUID=4da26f54-7150-4d18-b520-ef99cc1bd6db rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
GRUB_ENABLE_BLSCFG=true

# the above becomes
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto resume=UUID=4da26f54-7150-4d18-b520-ef99cc1bd6db"
GRUB_DISABLE_RECOVERY="true"
GRUB_ENABLE_BLSCFG=true

# then run the command below to refresh grub
grub2-mkconfig -o /boot/grub2/grub.cfg
```

16. Create a new logical volume according to the following requirements:
The logical volume is named database and belongs to the datastore volume group and
has a size of 50 extents. Logical volumes in the datastore volume group
should have an extent size of 16 MB.
Format the new logical volume with a ext4 filesystem.
The logical volume should be automatically mounted under /mnt/database at system
boot time.
```console
# create a partition using fdisk if no free partition exist
[root@localhost ~]# fdisk /dev/sda
Welcome to fdisk (util-linux 2.32.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x815fac7b.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-10485759, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-10485759, default 10485759): +1G

Created a new partition 1 of type 'Linux' and of size 1 GiB.
# make the new partition an LVM

Command (m for help): t
Selected partition 1
Hex code (type L to list all codes): 8e
Changed type of partition 'Linux' to 'Linux LVM'.

# verify the partitions and type
Command (m for help): p
Disk /dev/sda: 5 GiB, 5368709120 bytes, 10485760 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x815fac7b

# create a volume group with physical extent of 16M
[root@localhost ~]# vgcreate datastore -s 16M /dev/sda1

# create the logical volume with an extent size of 50
[root@localhost ~]# lvcreate -n database -l 50 datastore

# make the file system
[root@localhost ~]# mkfs.ext4 /dev/datastore/database

# make the mount point
[root@localhost ~]# mkdir /mnt/database

# add the mount point to /etc/fstab
[root@localhost ~]# echo "/dev/datastore/database /mnt/database ext4 defaults 0 0" >> /etc/fstab

[root@localhost ~]# findmnt --verify
Success, no errors or warnings detected
[root@localhost ~]# mount -a

```
