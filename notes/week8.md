### Week eight study note (5/28/2023 - 6/03/2023)<!-- omit from toc -->

#### Linux OS hardening continued.
##### Secure SSH Configuration
To secure ssh configuration, edit the ssh config file `/etc/ssh/sshd_config`. There are multiple changes that can be made to better secure ssh, the following are the most common ones.

1. `#Port 22` , this can edited to another port number. Port 22 is the default port for ssh. Remember to allow the new port number through firewall.
2. `#PermitRootLogin yes` &rarr; `PermitRootLogin no`. This will disable root login through ssh, to use root via ssh, login as a regular user then switch to the root account if needed. However, the preferred method is to use the `sudo` command to gain root privilege when needed.
3. 