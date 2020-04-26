# To Administer EBS Volume

### To Login to remote instance (ubuntu) that we are creating with SSH

ssh -i  mykey -l ubuntu <instance_public_ip>

### to switch to root user
```
$ sudo -s
```
# gives disk information

to see list of disk
```
$ df -h
```
```
fdisk -l
```

### Format the disk to ext4 file system
 ***device_name = /dev/xvdh***
## this mounts the hard drive into this directory
```
mkfs.ext4 /dev/xvdh
```

### Mount Data
```
mkdir /data
mount /dev/xvdh /data
```

At this stage this volume needs to go into /etc/fstab
NB: fstab: Fstab is your operating system’s file system table.

```
vim /etc/fstab
```

Add the following lines
```
/dev/xvdh /data ext4 defaults 0 0
```

mount and unmount data
```
mount
unmount
```

This will make the volume /data always available even after reboot, which will make for Immutable infrastructure


