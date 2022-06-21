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
exit
