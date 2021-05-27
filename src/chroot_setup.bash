#!/bin/sh

. /etc/archbox.conf >/dev/null 2>&1

set --

# Text colors/formatting
red="\033[38;5;1"
green="\033[38;5;2"
bold="\033[1m"
reset="\033[m"

err(){
    printf "${red}${bold}%s${reset}\n" "==> $*" 1>&2
    exit 1
}

msg(){
    printf "${green}${bold}%s${reset}\n" "==> $*" 1>&2
}

PATH=/usr/bin

msg "Initializing pacman keyrings..."
pacman-key --init
pacman-key --populate archlinux
msg "Installing essential packages..."
pacman -Syu base base-devel xorg pulseaudio nano --noconfirm
msg "Installing archboxctl..."
mkdir -p /usr/local/bin
curl https://raw.githubusercontent.com/lemniskett/archboxctl/master/archboxctl.bash > /usr/local/bin/archboxctl
chmod 755 /usr/local/bin/archboxctl
msg "Setting up locale..."
echo "Uncomment needed locale, enter to continue"
read
nano /etc/locale.gen
locale-gen
msg "Setting up timezone..."
echo "Enter your timezone, for example : \"Asia/Jakarta\"" 
while true; do
	read TIMEZONE \
		&& [[ -e /usr/share/zoneinfo/$TIMEZONE ]] \
		&& ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
		&& break \
		|| echo "Timezone not found, enter it again."
done
msg "Creating user account..."
CHROOT_USER="$(cat /tmp/archbox_user)"
useradd -m $CHROOT_USER
gpasswd -a $CHROOT_USER wheel
echo "Enter root password"
while true; do
	passwd && break
done
echo "Enter $CHROOT_USER password"
while true; do
	passwd $CHROOT_USER && break
done
sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
echo "Don't forget to run \"archbox --mount\" in host on boot"
