#!/bin/bash

vg="$(hostname)-vg"

# configure lvm
lvreduce -r -L 750G /dev/$vg/home
lvextend -r -L 128G /dev/$vg/root

swapoff -v /dev/$vg/swap_1
lvresize /dev/$vg/swap_1 -L 16G
mkswap /dev/$vg/swap_1
swapon -va

lvextend -r -l +100%FREE /dev/$vg/home

# configure auto-mount for encrypted drives

if [[ ! -d /etc/luks-keys ]]; then
    mkdir /etc/luks-keys
    chmod 700 /etc/luks-keys
fi

function configure_drive() {
    disk_id=$1
    partition_id=$2
    mount_point=$3

    echo "luks-$disk_id UUID=$disk_id /etc/luks-keys/luks-$disk_id nofail" >> /etc/crypttab
    echo "/dev/disk/by-uuid/$partition_id $mount_point auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab

    read -p "Enter passphrase for $mount_point: " password

    echo -n "$password" > /etc/luks-keys/luks-$disk_id
}

configure_drive "01c6ec40-8106-4503-ab2a-7dbfd53439b4" "b315385b-cdba-4471-9b82-dd532c38f228" "/media/Home"
configure_drive "88a6b901-6969-4f4f-a3c2-e91ec860d86b" "26529d89-8020-4fe5-84f1-c4a137e8786e" "/media/Data"
