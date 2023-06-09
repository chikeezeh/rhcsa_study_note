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

##### nice and renice
Another way of keeping your system fine-tuned is by prioritizing processes through `nice` and `renice` command.

With `nice` and `renice` commands we can make the system to give preference to certain processes than others, this priority can be set at 40 different levels (-20 highest priority to 19 lowest priority)

###### nice and renice usage

```console
# Launch a program with altered priority:
nice -n niceness_value command
```
```console
# Change priority of a running process:
renice -n niceness_value -p pid

# Change priority of all processes owned by a user:
renice -n niceness_value -u user

# Change priority of all processes that belong to a process group:
renice -n niceness_value --pgrp process_group
```
#### Containers in Linux
Containers are used to package the resources (software code, libraries, and configuration files) that an application needs so that it can be run across multiple machines regardless of the architecture.

##### Types of containers
1. `Docker` is a populare container technology that was developed by Solomon Hykes in 2013, it can be used to create and manager containers.
2. `Podman` is an alternative to `Docker` that was created by RedHat in 2018, it is daemon less, open source, Linux-native designed to develop, manage, and run containers.

##### RedHat container technology
* `podman` &rarr; for directly managing pods and container images (run, stop, start, ps, attach, etc.) 
* `buildah` &rarr; for building, pushing, and signing container images.
* `skopeo` &rarr; for copying, inspecting, deleting, and signing images.
* `runc` &rarr; for providing container run and build features to `podman` and `buildah`.
* `crun` &rarr; an optional runtime that can be configured and gives greater flexibility, control, and security for rootless containers.

##### Building, Running and Managing Containers

```console
# List running container
podman ps

# List all containers created
podman ps -a

# Pull an image
podman pull vaultwarden/server:latest

# List images in local storage
podman images

# Delete a container
podman rm <container-name>

 tldr:podman
# podman
# Simple management tool for pods, containers and images.
# Podman provides a Docker-CLI comparable command-line. Simply put: `alias docker=podman`.
# More information: <https://github.com/containers/podman/blob/main/commands-demo.md>.

# List all containers (both running and stopped):
podman ps --all

# Create a container from an image, with a custom name:
podman run --name container_name image

# Start or stop an existing container:
podman start|stop container_name

# Pull an image from a registry (defaults to Docker Hub):
podman pull image

# Display the list of already downloaded images:
podman images

# Open a shell inside an already running container:
podman exec --interactive --tty container_name sh

# Remove a stopped container:
podman rm container_name

# Display the logs of one or more containers and follow log output:
podman logs --follow container_name container_id
# source: cheat.sh/podman
```
#### Kickstart (Automate Linux Installation)
Kickstart is a method to automate the Linux installation without the need for any intervention from the user. This can be used to select the system configuration, drive partitions, packages to be installed etc.

##### Steps for Kickstart
1. Choose a Kickstart server and create/edit a Kickstart file
2. Make the Kickstart file available on a network location
3. Make the installation source available
4. Make boot media available for client which will be used to begin the installation
5. Start the Kickstart installation
   

#### System Run Levels (0 through 6)

A run level is a preset operating state on a Unix-like operating system.

<p>A system can be booted into (i.e., started up into) any of several runlevels, each of which is
represented by a single digit integer. Each runlevel designates a different system configuration
and allows access to a different combination of processes (i.e., instances of executing programs).
The are differences in the runlevels according to the operating system. Seven runlevels are
supported in the standard Linux kernel (i.e., core of the operating system). They are:</p>

* 0 - System halt; no activity, the system can be safely powered down.
* 1 - Single user; rarely used.
* 2 - Multiple users, no NFS (network filesystem); also used rarely.
* 3 - Multiple users, command line (i.e., all-text mode) interface; the standard runlevel for most Linux-based server hardware.
* 4 - User-definable
* 5 - Multiple users, GUI (graphical user interface); the standard runlevel for most Linux-based desktop systems.
* 6 - Reboot; used when restarting the system.

To access the different run levels, you can use the command `init <run_level_integer>` for example; `init 6` will reboot the system.

#### Computer Boot Process

In general, the computer boot process is similar across all modern machines. This process is called `bootstrap` in IT terminology.

1. Power on the machine via the power button.
2. The CPU is started, and pulls information from the BIOS (Basic Input/Uutput System). The BIOS is a small chip installed by the manufacturer which has information needed to boot in the system in a ROM (Read Only Memory).
3. The BIOS also, looks for extra information such as the BIOS settings, system time, date, and hardware settings from another chip called CMOS (Complimentary metal-oxide semiconductor). The CMOS chip is powered by a battery, so it retains the information needed even after the system has been powered off.
4. The BIOS sends a POST (Power on self test) to every device connected to the system, if there is any faulty device the system won't power on.
5. The BIOS then goes to the storage to find the MBR (Master boot record)
6. The operating system gets loaded in the RAM (Random Access Memory)
7. The operating system then takes over and loads the programs it needs which are then processed in the CPU.