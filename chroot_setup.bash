#!/bin/bash

err(){
    echo "$(tput bold)$(tput setaf 1)==> $@ $(tput sgr0)"
    exit 1
}

msg(){
    echo "$(tput bold)$(tput setaf 2)==> $@ $(tput sgr0)"
}

msg "Initializing pacman keyrings..."
pacman-key --init
pacman-key --populate archlinux
msg "Installing essential packages..."
pacman -Syu base base-devel xorg --noconfirm
msg "Creating user account..."
echo "Enter the name of the user account, you may want it to be the same as the host os so it will share the same home directory"
read CHROOT_USER
useradd -m $CHROOT_USER
gpasswd -a $CHROOT_USER wheel
echo "Enter root password"
passwd
echo "Enter $CHROOT_USER password"
passwd $CHROOT_USER
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
