# RHCSA practice exam

## Understand and use essential tools

Login to `server-0`. Run the the command `ss` issueing the `tulpen` option.

1. Write the opened ports into a file called `/tmp/openports.txt`.
2. This file should be owned by the owner `root` and the group `ec2-user`.
3. The file should be readable by the owner and the group, but not by others.
4. Create a soft link to the file in the `/tmp` directory called `/tmp/softlink.txt`.
5. Create a hard link to the file in the `/tmp` directory called `/tmp/hardlink.txt`.
6. Find the package that containers /usr/share/dics/words and install it.
7. Find all occurrences of the pattern `red` in the file `/usr/share/dics/words`. Write the resulting number into a file called `/tmp/redwords.txt`.
8. Compress the file `/tmp/redwords.txt` with `gzip` and call it `/tmp/redwords.txt.gz`. Keep the file /tmp/redwords.txt in tact.

## Create simple shell scripts

1. Create a script (`/tmp/script.sh`) that prints the day if it's a weekday. (Monday to Friday)
2. Create another script (`/tmp/other-script.sh`) that read the first argument and print the name of the day if it's a weekday, otherwise exists in error

## Operate running systems

1. Set the boot targetmode to `multi-user.target`.
2. Prioritize the process `/usr/bin/rhsmcertd` with the priority `10`.
3. Activate the tuned profile `powersave`.
4. Write all occurences of the pattern `DHCP` from the first bootlog into a file called `/tmp/dhcp.txt`.
5. Have journalctl write all logs to a persistent storage.
6. Copy the file /etc/hosts to server-1.adfinis.dev in the /tmp directory.

## Configure local storage

1. Create a LVM volume group named `vgroup` on /dev/nvme1n1.
2. Create a 1GiB LVM logical volume named `lvol` inside the "vgroup" LVM volume group.
3. The `lvol` LVM logical volume should be formatted with the `ext2` filesystem and mounted persistently on the `/lvol` directory using the universally unique ID (UUID).
4. Configure a basic web server that displays `Welcome to the RHCSA Practice Exam!` once connected to it.
5. Create a swap file (`/swapfile`) of 1GiB and activate it persistently.

## Create and configure file systems

1. On `server-0`, create an NFS export of the `/var/www/html` directory, allowing `192.168.1.0/24` to access it.
2. Mount the NFS export on `server-1` in the `/mnt` directory.
3. On server-1, automatically mount /opt when accessed, mounted from server-0:/var/www/html.
4. Extend /dev/vgroup/lvol to 2GiB.
5. Create a set-GID directory called `/collab` that allows all users to write to it, but only the owner to delete files.

## Deploy, configure, and maintain systems

1. Configure the system to use the `ntp1.example.net` NTP server.
2. Add the package repository hosted on `https://repo.example.com` to the system.
3. Add a `quiet` arguemnt to the bootloader.
4. Add a job to root crontab that runs the command `echo "Hello world."` every other day.

## Manage basic networking

1. Configure `eth0` with a fixed IP address.
2. Configure the search domain `adfins.dev`.
3. Install `firewalld`, add the services `http`, `https`, `nfs` and `ssh` permanently.

## Manage users and groups

39 Create a user `johndoe` with the UID `1001`.
40 Set the password for the user `johndoe` to `redhat`.
41 Add the user `johndoe` to the group `users`.
42 Change the password aging for the user `johndoe` to 90 days.
43 Create a group `admins` with the GID `2001`.
44 Add the user `johndoe` to the group `admins`.
45 Allow the group `admin` to execute the command `systemctl` without a password.

## Manage security

46 Set a umask of `027` for all users.
47 On server-0, create a key pair for the user `root` and copy the public key to server-1.
48 Enable SELinux at boot.
49 Set SELinux to enforcing mode.
50 Save the SELinux context of the file `/etc/hosts` to `/tmp/hosts_context`.
51 Restore the default file contexts of the `/var/www` directory, recursively.
52 Allow the target `http_port_t` to listen on port `8080`.
53 Enable the SELinux boolean `httpd_can_network_connect`.
54 Display all SELinux alerts (if any) with a reason why to `/tmp/selinux_alerts`.

## Manage containers

55 Install `podman`, Login to the registry `quay.io`.
56 Pull the image `rhel9/cups`
57 Find and retrieve container images from a remote registry
58 Store the `Size` of the image in a file called `/tmp/image_size.txt`.
59 Run the container `rhel9/cups` in the background.
60 Based on the `Containerfile` below, build a container image called `myhttpd`.

```text
FROM centos:8
RUN dnf -y install httpd
CMD [“/usr/sbin/httpd”, “-D”, “FOREGROUND”]
```

61 Create a service file for the container `myhttpd` that starts the container at boot.
62 Attach the directory `/var/www/html` to the container `myhttpd` for persistent storage.
