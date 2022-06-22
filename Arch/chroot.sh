#!/bin/bash
echo tmak2002 > /etc/hostname
echo LANG=de_DE.UTF-8 > /etc/locale.conf
echo KEYMAP=de-latin1 > /etc/vconsole.conf
sed -i 's/#de_DE.UTF-8/de_DE.UTF-8/g' /etc/locale.gen
locale-gen
ln -sf /usr/share/timezone/Europe/Berlin /etc/localtime
mkinitcpio -p linux
passwd
bootctl install
# User Setup
useradd -m -U -G wheel -s /bin/bash torben
passwd torben
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
pacman -S xorg-server xorg-xinit \
  i3-gaps polybar jgmenu \
  pulseaudio pavucontrol \
  firefox rxvt-unicode \
  git \

git clone https://github.com/tmak2002/dotfiles /home/torben/dotfiles
cd /home/torben/dotfiles && bash install.sh
exit
