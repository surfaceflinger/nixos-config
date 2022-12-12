# Blahaj.

## Create encrypted pool with stripe:

```
zpool create -f \
  -o ashift=12 \
  -o autotrim=on \
  -O acltype=posixacl \
  -O relatime=on \
  -O xattr=sa \
  -O dnodesize=auto \
  -O normalization=formD \
  -O utf8only=on \
  -O devices=off \
  -O compression=lz4 \
  -O encryption=aes-256-gcm \
  -O keyformat=passphrase \
  -O keylocation=prompt \
  -R /mnt \
  -O mountpoint=none \
  blahaj \
  /dev/disk/by-id/ata-CT250MX500SSD1_2141E5D95F83-part2 /dev/disk/by-id/ata-CT250MX500SSD1_2141E5D95F96
```

Once zpool is imported, every dataset that's marked as canmount=on and has set mountpoint will be mounted automatically. `-R /mnt` will prefix every dataset mountpoint with `/mnt` (temporarily, for OS installation only).

Every `-O` attribute passed to `zpool create` is actually some `-o` setting for dataset. Setting them to zpool will make it so every dataset will have these by default. This includes encryption - zpool isn't encrypted, datasets are.

## Create datasets.

```
zfs create -o canmount=off -o mountpoint=none     blahaj/NixOS
zfs create -o canmount=off -o mountpoint=/etc     blahaj/NixOS/etc
zfs create -o canmount=on                         blahaj/NixOS/etc/nixos
zfs create -o canmount=on  -o mountpoint=/home    blahaj/NixOS/home
zfs create -o canmount=on  -o mountpoint=/nix     blahaj/NixOS/nix
zfs create -o canmount=on  -o mountpoint=/persist blahaj/NixOS/persist
zfs create -o canmount=off -o mountpoint=/var     blahaj/NixOS/var
zfs create -o canmount=on                         blahaj/NixOS/var/lib
zfs create -o canmount=on                         blahaj/NixOS/var/log
zfs create -o canmount=off -o mountpoint=/vol     blahaj/NixOS/vol
zfs create -o canmount=on                         blahaj/NixOS/vol/Games
```

Why datasets like `blahaj/NixOS/etc` have mountpoints but `canmount` is set to `off`? - Well, you don't have to create them at all. It'll just work like a `container` for eg. `blahaj/NixOS/etc/nixos` so `zfs show` can show sum of used space and "slave" datasets will inherit parent `-o` options.

If you want to eg. create just `blahaj/NixOS/etc/nixos` then you will have to setup its mountpoint.

In my example it'll just inherit `mountpoint=/etc` and because it's a "slave" dataset - it'll transparently append `/nixos` to the end.

## Example result

`# zfs list`

```
NAME                     USED  AVAIL     REFER  MOUNTPOINT
blahaj                   151G   297G      192K  none
blahaj/NixOS            24.5G   297G      192K  none
blahaj/NixOS/etc        4.54M   297G      192K  /etc
blahaj/NixOS/etc/nixos  4.35M   297G     4.35M  /etc/nixos
blahaj/NixOS/home       14.2G   297G     14.2G  /home
blahaj/NixOS/nix        8.18G   297G     8.18G  /nix
blahaj/NixOS/persist     248K   297G      248K  /persist
blahaj/NixOS/var        2.04G   297G      192K  /var
blahaj/NixOS/var/lib    2.04G   297G     2.04G  /var/lib
blahaj/NixOS/var/log     272K   297G      272K  /var/log
blahaj/vol               126G   297G      200K  /vol
blahaj/vol/Games         126G   297G      126G  /vol/Games
```
