### Practice Questions and Answers<!-- omit from toc -->

1. Configure YUM repos with the given link ( 2 repos: 1st is BaseOS and 2nd is AppStream ) base_url= http://content.example.com/rhel8.0/x86_64/dvd/BaseOS AppStream_url= http://content.example.com/rhel8.0/x86_64/dvd/AppStream
```console
#create a file in /etc/yum.repos.d directory that ends in .repo
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
