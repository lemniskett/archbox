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
pacman -Syu base base-devel xorg pulseaudio nano --noconfirm
msg "Installing servicectl..."
mkdir -p /usr/local/share/servicectl/enabled
curl -L 'https://raw.githubusercontent.com/lemniskett/servicectl/master/servicectl' > /usr/local/share/servicectl/servicectl 2>/dev/null
curl -L 'https://raw.githubusercontent.com/lemniskett/servicectl/master/serviced' > /usr/local/share/servicectl/serviced 2>/dev/null
chmod +x /usr/local/share/servicectl/service{d,ctl}
ln -s /usr/local/share/servicectl/servicectl /usr/local/bin/servicectl
ln -s /usr/local/share/servicectl/serviced /usr/local/bin/serviced
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
		|| err "Timezone not found"
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
echo "Don't forget to run '/usr/local/share/archbox/bin/archboxinit start' in host on boot"
