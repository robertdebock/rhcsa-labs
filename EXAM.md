# RHCSA exam prep

## Understand and use essential tools

1. Login to `server-0.adfinis.dev`.
2. Run the the command `ss` issueing the `tulpen` option.
3. Write the opened ports into a file called `/tmp/openports.txt`.
4. This file should be owned by the owner `root` and the group `ec2-user`.
5. The file should be readable by the owner and tkkhe group, but not by others.
6. Create a soft link to the file in the `/tmp` directory called `/tmp/softlink.txt`.
7. Create a hard link to the file in the `/tmp` directory called `/tmp/hardlink.txt`.
8. Find the package that containers /usr/share/dics/words and install it.
9. Find all occurrences of the patther `red` in the file `/usr/share/dics/words`. Write the resulting number into a file called `/tmp/redwords.txt`.
10. Compress the file `/tmp/redwords.txt` with `gzip` and call it `/tmp/redwords.txt.gz`.

## Create simple shell scripts

11. Create a script (`/tmp/script.sh`) that prints the day if it's a weekday. (Monday to Friday)
12. Let the script read the first arugment and print it if it's a weekday, otherwise print the current date.

## Operate running systems

13. Set the boot targetmode to `multi-user.target`.
14. Reboot the system.
15. Prioritize the process `/usr/bin/rhsmcertd` with the priority `10`.
16. Kill the running process `/usr/bin/rhsmcertd`.
17. Activate the tuned profile `powersave`.
18. Write all occurences of the patthen `DHCP` from the first bootlog into a file called `/tmp/dhcp.txt`.
19. Have journalctl write all logs to a persistent storage.
20. Copy the file /var/log/messages to server-1.adfinis.dev in the /tmp directory.

## Configure local storage

21. Create a LVM volume group named `vgroup` on /dev/nvme1n1.
22. Create a 1GiB LVM logical volume named `lvol` inside the "vgroup" LVM volume group.
23. The `lvol` LVM logical volume should be formatted with the `ext2` filesystem and mounted persistently on the `/lvol` directory using the universally unique ID (UUID).
24. Configure a basic web server that displays `Welcome to the RHCSA Practice Exam!` once connected to it.
25. Create a swap file of 1GiB and activate it.

## Create and configure file systems

26. On `server-0`, create an NFS export of the `/var/www/html` directory.
27. Mount the NFS export on `server-1` in the `/mnt` directory.

28. On server-1, automatically mount /opt when accessed, mounted from server-0:/var/www/html.
29. Extend /dev/vgroup/lvol to 2GiB.
30. Create a set-GID directory called `/collab` that allows all users to write to it, but only the owner to delete files.

## Deploy, configure, and maintain systems

31. Configure the system to use the `ntp1.example.net` NTP server.
32. Add the package repository hosted on `https://repo.example.com` to the system.
33. Add a `quiet` arguemnt to the bootloader.
34. Add a job to root crontab that runs the command `echo "Hello world."` every other day.

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

- [x] Configure firewall settings using firewall-cmd/firewalld
- [x] Manage default file permissions
- [x] Configure key-based authentication for SSH
- [x] Set enforcing and permissive modes for SELinux

```bash
dnf -y install libselinux-utils
setenforce (Enforcing|Permissive)
getenforce
# Permanently set SELinux to enforcing or permissive mode
vi /etc/selinux/config
SELINUX=enforcing
reboot
```

- [x] List and identify SELinux file and process context

```bash
ls -Z # Third column is the context.
ps -eZ # Third column is the context.
id -Z
cat /etc/selinux/targets
```

- [x] Restore default file contexts

```bash
restorecon -rv /var/www/
```

- [x] Manage SELinux port labels

```bash
semanage port -l
semanage port -a -t http_port_t -p tcp ${port}
semanage port -d -t http_port_t -p tcp ${port}
```

- [x] Use boolean settings to modify system SELinux settings

```bash
getsebool -l
setsebool -P zabbix_can_network on
```

- [x] Diagnose and address routine SELinux policy violations

```bash
cat /var/log/audit/audit.log | audit2why
cat /var/log/audit/audit.log | audit2allow
dnf -y install setroubleshoot-server
sealert -a /var/log/audit/audit.log
```

## Manage containers

- [ ] Find and retrieve container images from a remote registry

```bash
podman login ${url}
podman search ${image}
podman pull ${image}
```

- [ ] Inspect container images

```bash
podman inspect ${image}
```

- [ ] Perform container management using commands such as podman and skopeo

```bash
podman run -it ${image} /bin/bash
```

- [ ] Build a container from a Containerfile

```bash
cat << EOF >> Containerfile
FROM centos:8
RUN dnf -y install httpd
CMD [“/usr/sbin/httpd”, “-D”, “FOREGROUND”]
EOF
podman build -t myhttpd .
```

- [ ] Perform basic container management such as running, starting, stopping, and listing running containers

```bash
dnf install podman
podman ps
podman stop ${container}
podman start ${container}
podman rm ${container}
```

- [ ] Run a service inside a container
  
```bash
podman run -d -p 8080:80 myhttpd
```

- [ ] Configure a container to start automatically as a systemd service

```bash
podman pull docker.io/library/httpd
mkdir -p /var/local/httpd
cat << EOF >> /var/local/httpd/index.html
<html>
  <header>
    <title>Enable SysAdmin</title>
  </header>
  <body>
    <p>Hello World!</p>
  </body>
</html>
EOF
podman run --name=httpd --hostname=httpd -p 8081:80 -v /var/local/httpd:/usr/local/apache2/htdocs:Z -d httpd
podman generate systemd --new --files --name httpd
mv container-httpd.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable container-httpd --now
```

- [ ] Attach persistent storage to a container

> As with all Red Hat performance-based exams, configurations must persist after reboot without intervention.

## Things to review

- [ ] Interrupt the boot process in order to gain access to a system
- [ ] Boot systems into different targets manually
- [ ] Preserve system journals
- [ ] Configure autofs
- [ ] Install and update software packages from Red Hat Network, a remote repository, or from the local file system
