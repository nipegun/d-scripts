apt-get install lvm2

    Run vgscan command scans all supported LVM block devices in the system for VGs
    Execute vgchange command to activate volume
    Type lvs command to get information about logical volumes
    Create a mount point using the mkdir command
    Mount an LVM volume using sudo mount /dev/mapper/DEVICE /path/to/mount
How to mount an LVM volume

Type the following command to find info about LVM devices:
$ sudo vgscan

OR
$ sudo vgscan --mknodes

Scan your Linux system for LVM volumes using vgscan

Above output indicates that I have “fedora_localhost-live” LVM group. To activate it run:
$ sudo vgchange -ay

OR
$ sudo vgchange -ay fedora_localhost-live

Activate the LVM volume using the vgchange command

You can run the following command to list it:
$ sudo lvdisplay

OR
$ sudo lvs

Shows information about available LVM logical volumes

You can get good look at using the ls command:
$ ls -l /dev/fedora_localhost-live/

Sample outputs:

total 0
lrwxrwxrwx 1 root root 7 Aug 17 15:47 home -> ../dm-1
lrwxrwxrwx 1 root root 7 Aug 17 15:47 root -> ../dm-2
lrwxrwxrwx 1 root root 7 Aug 17 15:47 swap -> ../dm-0

Mount an LVM partition

Create a mount point using the mkdir command:
$ sudo mkdir -vp /mnt/fedora/{root,home}

Sample outputs:

mkdir: created directory '/mnt/fedora/root'
mkdir: created directory '/mnt/fedora/home'

Mount both home and root logical volume from LV path using the following syntax:
$ sudo mount {LV_PATH} /path/to/mount/point/
$ sudo mount /dev/fedora_localhost-live/home /mnt/fedora/home
$ sudo mount /dev/fedora_localhost-live/root /mnt/fedora/root

Verify it with the help of df command or grep command:
$ df -T
$ df -T | grep -i fedora
$ ls /mnt/fedora/root
$ ls /mnt/fedora/home

How to mount an LVM volume and verify it on Linux

Click to enlarge image
Update /etc/fstab

Update /etc/fstab file if you want a logical volume to be mounted automatically on boot:
/dev/mapper/fedora_localhost--live-root /mnt/fedora/root ext4 defaults 0 0
/dev/mapper/fedora_localhost--live-home /mnt/fedora/home ext4 defaults 0 0
