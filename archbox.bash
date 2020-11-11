#!/bin/bash

source /etc/archbox.conf

checkdep(){
    which $1 >/dev/null 2>&1 || err "Install $1!"
}

copyresolv(){
    $PRIV /usr/local/share/archbox/bin/copyresolv
}

asroot(){
    [[ $EUID -ne 0 ]] && err "Run this as root!"
}

storeenv(){
    echo $DBUS_SESSION_BUS_ADDRESS > /tmp/archbox_dbus_session_address
    echo $XDG_RUNTIME_DIR > /tmp/archbox_xdg_runtime_dir
}

help_text(){
cat << EOF
USAGE: $0 <arguments>

OPTIONS:
  -c, --create URL      Creates a chroot enviroment.
  -e, --enter           Enters chroot enviroment.
  -h, --help            Displays this help message.
  --remount-run		Remount /run in chroot enviroment.

EOF
}

err(){
    echo "$(tput bold)$(tput setaf 1)==> $@ $(tput sgr0)"
    exit 1
}

msg(){
    echo "$(tput bold)$(tput setaf 2)==> $@ $(tput sgr0)"
}

case $1 in
    -c|--create)
        asroot
        [[ -z $2 ]] && err "Specify the link of Arch Linux bootstrap tarball!"
        msg "Creating chroot directory..."
        mkdir -p $INSTALL_PATH
        cd $INSTALL_PATH
        msg "Downloading Arch Linux tarball..."
        checkdep wget
        wget -q --show-progress -O archlinux.tar.gz $2
        msg "Extracting the tarball..."
        tar xzf archlinux.tar.gz
        msg "Enabling internet connection in chroot enviroment..."
        cp /etc/resolv.conf $CHROOT/etc/resolv.conf
        msg "You will need to edit which mirror you want to use, uncomment needed mirrors and save it."
        echo "Editor of your choice:"
        read MIRROR_EDITOR
        $MIRROR_EDITOR $CHROOT/etc/pacman.d/mirrorlist || exit 1
        msg "Disabling Pacman's CheckSpace..."
        checkdep sed
        sed -i 's/CheckSpace/#CheckSpace/g' $CHROOT/etc/pacman.conf
        msg "Mounting necessary filesystems..."
        mount -R /home $CHROOT/home
        mount -t proc /proc $CHROOT/proc
        mount -R /tmp $CHROOT/tmp
        mount -R /sys $CHROOT/sys
        mount -R /dev $CHROOT/dev
        mount -R /run $CHROOT/run
        mount --make-rslave $CHROOT/dev
        mount --make-rslave $CHROOT/sys
        mkdir -p $CHROOT/var/lib/dbus
        mount -R /var/lib/dbus $CHROOT/var/lib/dbus
        mkdir -p $CHROOT/lib/modules
        mount -R /lib/modules $CHROOT/lib/modules
        mount -R /boot $CHROOT/boot
	cp /usr/local/share/archbox/chroot_setup.bash $CHROOT/chroot_setup
	echo $USER > /tmp/archbox_user
	chroot $CHROOT /bin/bash -c "sh /chroot_setup"
    ;;
    -e|--enter)
	storeenv
	copyresolv
        $PRIV /usr/local/share/archbox/bin/archbox enter
	;;
    --remount-run)
	$PRIV /usr/local/share/archbox/bin/remount_run
	;;
    -h|--help)
        help_text
    ;;
    "")
        help_text
    ;;
    -*)
        err "Unknown option: $1"
    ;;
    *)
	storeenv
    	copyresolv
	$PRIV /usr/local/share/archbox/bin/archbox $@
    ;;
esac
