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

#### Creating files and directories

Files can be created in Linux using various different commands.
<b>touch</b> &rarr; This command can be used to create a new file or update the timestamp of an existing file.
```console
┌──[08:22:56]─[0]─[root@almanode1:~/scripts/tester]
└──| ll
total 0
drwxr-xr-x. 2 root root 6 Apr 10 07:58 adirectory
-rw-r--r--. 1 root root 0 Apr 10 07:58 afile
┌──[08:22:57]─[0]─[root@almanode1:~/scripts/tester]
└──| touch file1
┌──[08:23:45]─[0]─[root@almanode1:~/scripts/tester]
└──| ll
total 0
drwxr-xr-x. 2 root root 6 Apr 10 07:58 adirectory
-rw-r--r--. 1 root root 0 Apr 10 07:58 afile
-rw-r--r--. 1 root root 0 Apr 10 08:23 file1
┌──[08:23:48]─[0]─[root@almanode1:~/scripts/tester]
└──|

```
<b>cp</b> &rarr; The copy command can also be used to create a new file, you copy an existing file and give it a new name to create a new file which can then be edited.
```console
┌──[08:26:10]─[0]─[root@almanode1:~/scripts/tester]
└──| cp file1 file2
┌──[08:26:18]─[0]─[root@almanode1:~/scripts/tester]
└──| ll
total 0
drwxr-xr-x. 2 root root 6 Apr 10 07:58 adirectory
-rw-r--r--. 1 root root 0 Apr 10 07:58 afile
-rw-r--r--. 1 root root 0 Apr 10 08:23 file1
-rw-r--r--. 1 root root 0 Apr 10 08:26 file2

```
<b>vi</b> &rarr; the vi command will open an existin or non-existing file in an editor, once changes are made the file can be saved hereby creating a new file.
```console
┌──[08:26:30]─[0]─[root@almanode1:~/scripts/tester]
└──| vi file3
┌──[08:28:45]─[0]─[root@almanode1:~/scripts/tester]
└──| ll
total 4
drwxr-xr-x. 2 root root 6 Apr 10 07:58 adirectory
-rw-r--r--. 1 root root 0 Apr 10 07:58 afile
-rw-r--r--. 1 root root 0 Apr 10 08:23 file1
-rw-r--r--. 1 root root 0 Apr 10 08:26 file2
-rw-r--r--. 1 root root 6 Apr 10 08:28 file3

```
<b>mkdir</b> &rarr; this command is used to create a directory
```console
┌──[08:31:14]─[0]─[root@almanode1:~/scripts/tester]
└──| mkdir dir1
┌──[08:31:18]─[0]─[root@almanode1:~/scripts/tester]
└──| ll -d dir1
drwxr-xr-x. 2 root root 6 Apr 10 08:31 dir1

┌──[08:33:36]─[0]─[root@almanode1:~/scripts/tester]
└──| mkdir dir{1..3}
┌──[08:33:42]─[0]─[root@almanode1:~/scripts/tester]
└──| ll -d dir*
drwxr-xr-x. 2 root root 6 Apr 10 08:33 dir1
drwxr-xr-x. 2 root root 6 Apr 10 08:33 dir2
drwxr-xr-x. 2 root root 6 Apr 10 08:33 dir3

```
#### Find files and directories
The are two main commands that are used to find files and directory on a Linux system.
* find
* locate

The `find` command iterates over the given path to find the file or directory, while the `locate` command uses a prebuilt database, which should be regularly updated. The `locate` command is much faster than the `find` command, however `locate` might be inaccurate if the database is not update.

##### Example using locate to find files that end with .sh
```console
┌──[11:04:01]─[0]─[root@almanode1:~/scripts/tester]
└──| updatedb #update the database that locate needs
┌──[11:04:28]─[0]─[root@almanode1:~/scripts/tester]
└──| locate */*.sh #this command locates all the .sh file on the system
/boot/grub2/i386-pc/modinfo.sh
/etc/X11/xinit/xinitrc.d/50-systemd-user.sh
/etc/X11/xinit/xinitrc.d/localuser.sh
```
##### Example using find to find files with the name less.sh
```console
┌──[11:08:01]─[0]─[root@almanode1:~/scripts/tester]
└──| find / -name less.sh
/etc/profile.d/less.sh
/usr/share/vim/vim82/macros/less.sh

```
#### Soft and Hard Links
This can be thought of as shortcuts pointing to a file or directory in another location. Soft links have a different inode number than the original file, while hard links has the same inode number as the original file. Hence, if the original file is deleted, the hard link will still remain, while the soft link will no longer work. Hard links can only be used for files, while soft link can be used for both file and directory.

##### Creating a hard link
```console
┌──[11:14:55]─[0]─[root@almanode1:~/scripts/tester]
└──| ln afile hardlink
```
##### Creating a soft link
```console
┌──[11:15:10]─[0]─[root@almanode1:~/scripts/tester]
└──| ln -s afile softlink
```
#### WildCards

* \* &rarr; represents zero or more characters
* ? &rarr; represents a single character
* [] &rarr; representa a range of characters

#### Basic Linux file permissions
There are 3 basic permissions for every file in the Linux system.
* r &rarr; read permission
* w &rarr; write permission
* x &rarr; execute permission
See the console output blow.
```console
-rwxr-xr-x. 1 root root 0 Mar  5 16:26 test.sh

```
Every file has 3 set of the permissions;
* The first 3 are the `u`ser(file owner) permissions
* The middle are the `g`roup (group of users) permissions
* The last 3 are the `o`thers (users outside of the primary file owner or group owner) permissions

##### Using chmod command to change permissions
The `chmod` command can be used to alter the permissions on a given file. This can either be alphabetic or numerical.

```console
Remove the executable permission from the user.
┌──[18:41:39]─[0]─[root@almanode1:~/scripts]
└──| ll test.sh
-rwxr-xr-x. 1 root root 0 Mar  5 16:26 test.sh
┌──[18:41:43]─[0]─[root@almanode1:~/scripts]
└──| chmod u-x test.sh
┌──[18:42:07]─[0]─[root@almanode1:~/scripts]
└──| ll test.sh
-rw-r-xr-x. 1 root root 0 Mar  5 16:26 test.sh
```
```console
Add write permission to group.
┌──[18:44:13]─[0]─[root@almanode1:~/scripts]
└──| chmod g+w test.sh
┌──[18:44:23]─[0]─[root@almanode1:~/scripts]
└──| ll test.sh
-rw-rwxr-x. 1 root root 0 Mar  5 16:26 test.sh

```
###### Using the numerical method to change permission.
`r`ead = 4
`w`rite = 2
e`x`ecute = 1
To get the number for each of `ugo`, we sum up the permissions we want to give them.
777 = rwxrwxrwx
700 = rwx------
600 = rw-------
```console
┌──[18:49:28]─[0]─[root@almanode1:~/scripts]
└──| ll test.sh
-rw-rwxr-x. 1 root root 0 Mar  5 16:26 test.sh
┌──[18:49:31]─[0]─[root@almanode1:~/scripts]
└──| chmod 777 test.sh
┌──[18:49:39]─[0]─[root@almanode1:~/scripts]
└──| ll test.sh
-rwxrwxrwx. 1 root root 0 Mar  5 16:26 test.sh

```
