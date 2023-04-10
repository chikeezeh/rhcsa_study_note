#### Linux File System Structure and Description


<b>/</b> &rarr; This is the apex directory in the Linux file system, it is called root directory.
<br/>
<b>/boot</b> &rarr; Contains files that is used by the boot loader (grub.cfg)
<br/>
<b>/root</b>  &rarr; This is called "slash root", this is the default root user home directory.
<br/>
<b>/dev</b> &rarr; System device files are found here, such as disk, keyboard etc.
<br/>
<b>/etc</b> &rarr; Configuration files.
<br/>
<b>/bin</b> &rarr; <b>/usr/bin</b> &rarr; Everyday user commands such as ls, cp, pwd etc.
<br/>
<b>/sbin</b> &rarr; <b>/user/sbin</b> &rarr; System/filesystem commands.
<br/>
<b>/proc</b> &rarr; Files for running processes (only exists in memory)
<br/>
<b>/tmp</b> &rarr; Directory for temporary files.
<br/>
<b>/home</b> &rarr; The home directory(s) of non root users can be found here.
<br/>
<b>/var</b> &rarr; Contains system log files.
<br/>
<b>/mnt</b> &rarr; Mount external file systems.
<br/>

#### File System Navigation commands
<b>cd</b> &rarr; change directory command, used to change into directory.
```console
 cd /etc
┌──[07:41:52]─[0]─[root@almanode1:/etc]
└──|
```
<b>pwd</b> &rarr; print working directory command.
```console
┌──[07:43:23]─[0]─[root@almanode1:/etc]
└──| pwd
/etc
```

<b>ls</b> &rarr; list the content of a directory, this command like most linux commands has various flags that can change the output of the content listed on the terminal, few examples below..
```console
┌──[07:47:00]─[0]─[root@almanode1:~]
└──| ls
anaconda-ks.cfg  history  linux_daily  pyconeapp  scripts  sysadmin_daily

┌──[07:47:17]─[0]─[root@almanode1:~]
└──| ls -l #long list
total 12
-rw-------.  1 root root 1097 Feb  5 23:42 anaconda-ks.cfg
drwxr-xr-x.  3 root root   37 Mar 30 21:51 history
drwxr-xr-x.  3 root root   25 Mar 20 16:26 linux_daily
drwxr-xr-x. 11 root root 4096 Mar 14 19:54 pyconeapp
drwxr-xr-x.  2 root root 4096 Mar 30 21:53 scripts
drwxr-xr-x.  3 root root   35 Mar 20 16:17 sysadmin_daily

┌──[07:48:40]─[0]─[root@almanode1:~]
└──| ls -la #shows hidden files
total 92
dr-xr-x---. 12 root root  4096 Apr  9 23:13 .
dr-xr-xr-x. 19 root root   257 Apr  8 18:55 ..
-rw-------.  1 root root  1097 Feb  5 23:42 anaconda-ks.cfg
-rw-------.  1 root root 14738 Apr  9 23:13 .bash_history
-rw-r--r--.  1 root root    18 Feb 10  2022 .bash_logout
-rw-r--r--.  1 root root   141 Feb 10  2022 .bash_profile
-rw-r--r--.  1 root root   659 Apr  1 18:50 .bash_prompt
-rw-r--r--.  1 root root   540 Mar 31 19:10 .bashrc
drwxr-xr-x.  4 root root    32 Mar 14 19:54 .bun
drwx------.  4 root root    28 Mar 30 20:31 .cache
drwx------.  4 root root    41 Mar 14 19:54 .config
```
<b>whoami</b> &rarr; used to check the current user logged on to the system.
```console
┌──[07:53:40]─[0]─[root@almanode1:~]
└──| whoami
root

```

#### Linux file and directory property
|Type and permissions| # of links| owner | group| size | date | name|
| :---               |:---: |:---: | :---:| :---:|:---:|---: |
|drwxr-xr-x.         | 2|root|root|6|Apr 10 07:58|adirectory|
|-rw-r--r--.|1|root|root|0|Apr 10 07:58|afile|

#### Linux file types
|File Symbol|Meaning|
| :--- |---: |
|-|Regular file|
|d|Directory|
|l|Link|
|c|Special file of device file|
|s|Socket|
|p|Named pipe|
|b|Block Device|
