#!/bin/bash
loadkeys de-latin1

read -p "Processor (amd, intel): " PROCESSOR
read -p "Graphics (amd, intel, nvidia)" GRAPHICS

curl -o chroot.sh https://raw.githubusercontent.com/tmak2002/Scripts/main/Arch/chroot.sh
curl -o loader.conf https://raw.githubusercontent.com/tmak2002/Scripts/main/Arch/loader.conf
curl -o arch.conf https://raw.githubusercontent.com/tmak2002/Scripts/main/Arch/arch.conf
pacman -Sy
timedatectl set-ntp true
sgdisk --zap-all -o /dev/sda
sgdisk -n 1::+312M -t 1:ef00 /dev/sda
sgdisk -n 2::+50G /dev/sda
sgdisk -n 3:: /dev/sda
mkfs.fat -F32 -n BOOT /dev/sda1
mkfs.ext4 -L ROOT /dev/sda2
mkfs.ext4 -L HOME /dev/sda3
mount /dev/sda2 /mnt
mkdir -p /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home

BASE=(base base-devel linux linux-firmware dhcpcd neovim)
[ "$PROCESSOR" == "intel" ] && BASE+=(intel-ucode)
[ "$PROCESSOR" == "amd" ] && BASE+=(amd-ucode)
[ "$GRAPHICS" == "nvidia" ] && BASE+=(nvidia nvidia-utils nvidia-settings)
[ "$GRAPHICS" == "intel" ] && BASE+=(xf86-video-intel)
[ "$GRAPHICS" == "amd" ] && BASE+=(xf86-video-amdgpu)
pacstrap /mnt ${BASE[@]}

genfstab -U /mnt >> /mnt/etc/fstab
mkdir -p /mnt/boot/loader/entries/
cp -v arch.conf /mnt/boot/loader/entries/arch.conf
cp -v loader.conf /mnt/boot/loader/loader.conf
cp -v chroot.sh /mnt/chroot.sh
chmod +x /mnt/chroot.sh
arch-chroot /mnt ./chroot.sh
rm /mnt/chroot.sh
umount -R /mnt
