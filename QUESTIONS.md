# RHCSA exam prep

## Understand and use essential tools

- [x] Access a shell prompt and issue commands with correct syntax
- [x] Use input-output redirection (>, >>, |, 2>, etc.)
- [x] Use grep and regular expressions to analyze text
- [x] Access remote systems using SSH
- [x] Log in and switch users in multiuser targets
- [x] Archive, compress, unpack, and uncompress files using tar, star, gzip, and bzip2
- [x] Create and edit text files
- [x] Create, delete, copy, and move files and directories
- [x] Create hard and soft links
- [x] List, set, and change standard ugo/rwx permissions
- [x] Locate, read, and use system documentation including man, info, and files in /usr/share/doc

## Create simple shell scripts

- [x] Conditionally execute code (use of: if, test, [], etc.)
- [x] Use Looping constructs (for, etc.) to process file, command line input
- [x] Process script inputs ($1, $2, etc.)
- [x] Processing output of shell commands within a script
Operate running systems
- [x] Boot, reboot, and shut down a system normally
- [x] Boot systems into different targets manually

[YouTube](https://www.youtube.com/watch?v=c328XfEARJ4)

```bash
systemctl get-default
systemctl list-units -type target
systemctl set-default (multi-user|graphical|rescue|emergency).target)
```

- [x] Interrupt the boot process in order to gain access to a system

[Documentation](https://www.redhat.com/sysadmin/interrupt-linux-boot-process)

```bash
 # add `rd.break` to grubs `linux` line.
 mount -o remount,rw /sysroot
 chroot /sysroot
 passwd root`
 
 # add `rw init=/bin/bash` to grubs `linux` line.
 passwd
 ```

- [x] Identify CPU/memory intensive processes and kill processes

```bash
top; ps -U root -u root u
pgrep -v -u root -l
kill ${pid}
pidof ${name}
```

- [x] Adjust process scheduling

[YouTube](https://www.youtube.com/watch?v=JPBQsTtHaIE)

```bash
chrt -p ${pid}
chrt -f -p ${priority} ${pid}
```

- [x] Manage tuning profiles

[Documentation](https://www.redhat.com/sysadmin/linux-tuned-tuning-profiles)

```bash
dnf install tuned tuned-profiles-mssql
tuned-adm list
tuned-adm active
tuned-adm recommend
tuned-adm profile ${profile:mssql}
```

- [x] Locate and interpret system log files and journals

```bash
journalctl —-list-boots
journaclt -b 0
```

- [x] Preserve system journals

[Documentation](https://www.redhat.com/sysadmin/store-linux-system-journals)

```bash
vi /etc/systemd/journald.conf
journal.storage=persist
systemctl restart systemd-journald
reboot
```

- [x] Start, stop, and check the status of network services
- [x] Securely transfer files between systems

## Configure local storage

- [x] List, create, delete partitions on MBR and GPT disks

[YouTube](https://www.youtube.com/watch?v=208_PXEsaD0)

```bash
dnf -y install lvm2
partprobe
fdisk -l
gdisk
swapon -a
```

- [x] Create and remove physical volumes
- [x] Assign physical volumes to volume groups
- [x] Create and delete logical volumes
- [x] Configure systems to mount file systems at boot by universally unique ID (UUID) or label

```bash
blkid
lsblk
```

- [x] Add new partitions and logical volumes, and swap to a system non-destructively

```bash
fallocate -l 1G /swapfile
swapon /swapfile
cat /proc/swaps
```

## Create and configure file systems

- [x] Mount and unmount network file systems using NFS

```bash
dnf -y install nfs-utils
echo “server:/export /mount defaults 0 0” >> /etc/fstab
mount -a
```

- [x] Create, mount, unmount, and use vfat, ext4, and xfs file systems
- [x] Configure autofs

```bash
dnf -y install autofs
echo “/opt auto.opt” >> /etc/auto.master
echo “bla -fstype=ext2 :/dev/sdb1” >> /etc/auto.opt
systemctl restart autos
```

- [x] Extend existing logical volumes
- [x] Create and configure set-GID directories for collaboration
- [x] Diagnose and correct file permission problems

## Deploy, configure, and maintain systems

- [x] Configure systems to boot into a specific target automatically

```bash
systemctl get-default
systemctl list-units -type target
systemctl set-default (multi-user|graphical|rescue|emergency).target
```

- [x] Configure time service clients

```bash
dnf -y install chrony
man chrony.conf
echo “server ntp1.example.net iburst” >> /etc/chrony.conf
systemctl restart chrony
```

- [x] Install and update software packages from Red Hat Network, a remote repository, or from the local file system

```bash
dnf repolist all
dnf repoinfo
dnf whatprovides ‘*/nano’
dnf localinstall PACKAGE.rpm
dnf install dnf-utils
yum-config-manager —add-repo https://repo.example.com
yum-config-manager —disable repo FOO
dnf install create reporepo
createrepo /directory
yum-config-manager —add-repo file:///directory
```

- [x] Modify the system bootloader

```bash
vi /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
```

- [x] Start and stop services and configure services to start automatically at boot
- [x] Schedule tasks using at and cron

```bash
dnf -y install at
systemctl enable adt —now
at 08:25
```

## Manage basic networking

- [x] Configure IPv4 and IPv6 addresses

```bash
nmtui
```

- [x] Configure hostname resolution

```bash
nmtui
```

- [x] Configure network services to start automatically at boot

```bash
systemctl start $service —now
```

- [x] Restrict network access using firewall-cmd/firewall

[YouTube](https://www.youtube.com/watch?v=ZNmTKAdDnrc)

```bash
for zone in $(firewall-cmd --get-zones) ; do
  firewall-cmd --zone ${zone} --list-all
done

firewall-cmd --get-services
firewall-cmd --add-service=http --permanent
firewall-cms --zone work --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --zone work --add-service=https --permanent
firewall-cmd --reload
firewall-cmd --list-all

# Assign an interface to a zone
firewall-cmd --get-active-zones
firewall-cmd --change-interface=${interface} --zone=${zone} --permanent
firewall-cmd --get-active-zones

firewall-cmd --add-port=${port}/tcp --permanent

firewall-cmd --add-zone ${zone} --permanent

# Other RHCSA firewall-cmd commands
firewall-cmd --get-default-zone
firewall-cmd --set-default-zone=${zone}
firewall-cmd --get-active-zones
firewall-cmd --zone=${zone} --add-service=${service} --permanent
firewall-cmd --zone=${zone} --add-port=${port}/tcp --permanent
firewall-cmd --zone=${zone} --add-port=${port}/udp --permanent
firewall-cmd --zone=${zone} --add-source=${ip} --permanent
```

## Manage users and groups

- [ ] Create, delete, and modify local user accounts

```bash
useradd -c “John Doe” -u 1001 johndoe
passwd johndoe
usermod -aG wheel johndoe
```

- [x] Change passwords and adjust password aging for local user accounts

```bash
chage -l johndoe
chage -M 90 johndoe
```

- [x] Create, delete, and modify local groups and group memberships

```bash
groupadd -g 2001 admins
usermod -aG admins johndoe 
```

- [x] Configure superuser access

```bash
visudo
```

## Manage security

- [ ] Configure firewall settings using firewall-cmd/firewalld
- [ ] Manage default file permissions
- [ ] Configure key-based authentication for SSH
- [ ] Set enforcing and permissive modes for SELinux
- [ ] List and identify SELinux file and process context
- [ ] Restore default file contexts
- [ ] Manage SELinux port labels
- [ ] Use boolean settings to modify system SELinux settings
- [ ] Diagnose and address routine SELinux policy violations

## Manage containers

- [ ] Find and retrieve container images from a remote registry
- [ ] Inspect container images
- [ ] Perform container management using commands such as podman and skopeo
- [ ] Build a container from a Containerfile
- [ ] Perform basic container management such as running, starting, stopping, and listing running containers
- [ ] Run a service inside a container
- [ ] Configure a container to start automatically as a systemd service
- [ ] Attach persistent storage to a container
- [ ] As with all Red Hat performance-based exams, configurations must persist after reboot without intervention.

## Things to review

- Interrupt the boot process in order to gain access to a system
- Boot systems into different targets manually
- Preserve system journals
- Configure autofs
- Install and update software packages from Red Hat Network, a remote repository, or from the local file system
