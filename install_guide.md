# Installation Guide for NixOS

The following will cover the steps on how to setup
a "common sense" configuration manually for a UEFI system during
the NixOS installation processs. It would be nice if all of this
could be declaratively defined but such is life.

> [!note]
> `#` denotes to run the command as root, while `$` denotes
> to run the command as a regular user.

## Pre-Install Process

Refer to [NixOS manual](https://nixos.org/manual/nixos/stable/) to see
the pre-installation process i.e. obtaining the .iso, burning it, etc.

## Getting Started

Before starting, check that your NVMe drive is using its [optimal logical sector size.](https://wiki.archlinux.org/title/Advanced_Format)
Now is also the time to do any [SSD memory cell cleaning](https://wiki.archlinux.org/title/Solid_state_drive/Memory_cell_clearing) 
to restore it to its factory default write performance.

## Disk Paritioning

Here, we will create a partition table for UEFI---using `/dev/nvme0n1` as the device
and `fdisk` to create said table.

> [!note]
> Use `lsblk` to check the name of the device
> you wish to partition.

1. Launch fdisk:

```bash
# fdisk /dev/nvme0n1
```

2. Create a `GPT` table by typing `g`.

3. Create a new partition with the `n` command.

4. Specify the partition number. It's advised to choose the
default number suggested by pressing the `Enter` key.

5. Enter the first sector. Just use the default (again, by pressing `Enter`).

6. Enter the final sector. Type `+1G` to create a 
1 *gibibyte* partition.

7. Repeat steps 3-6 but for step 6 use the default value
instead.

8. Press `t` to change the partition type. It will prompt for
a partition number. Type `1`.

9. Type `uefi`.

10. Repeat steps 8-9 but type `2` for step 8 and type
`23` for step 9.

You should now have a complete partition table---with a 1 GiB boot partition
and the rest of the drive's space going to the root partition. Type `p` to print
the changes which `fdisk` will write in just a moment.

If all looks good, type `w` and the partition table will be written.

> [!note]
> Use:
> ```bash
> sudo -i
> ````
> in order to become the superuser.

## Encryption

Here, we will setup the luks encryption layer using `/dev/nvme0n1` as our device:

```bash
# cryptsetup luksFormat /dev/nvme0n1

# cryptsetup luksOpen /dev/nvme0n1 cryptroot
```

Now format the drive to whatever filesystem you wish; here we will use `ext4` and
label the partition as `nixos`:

```bash
# mkfs.ext4 -L nixos /dev/mapper/cryptroot
```

Don't forget about the `boot` partition---which will be labeled as `boot`:

```bash
# mkfs.fat -F 32 -n boot /dev/nvme0n1p1
```

Mount the partitions:

```bash
# mount /dev/mapper/cryptroot /mnt

$ mkdir -p /mnt/boot
# mount -o umask=077 /dev/nvme0n1p1 /mnt/boot
```

## Git

If you store your NixOS configuration files on GitHub (or any remote git repo), we will go
over the steps to retrieve it.

First, run the following:

```bash
# nix-shell -p git --run "git clone https://github.com/notKuta/nixos-config.git"
```


## Sources

https://nixos.org/manual/nixos/stable/#sec-installation

https://wiki.nixos.org/wiki/Full_Disk_Encryption

https://wiki.archlinux.org/title/Systemd-cryptenroll

https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LUKS_on_a_partition_with_TPM2_and_Secure_Boot
