#!/usr/bin/env bash

source /etc/archbox.conf

checkdep(){
    hash $1 2>/dev/null || err "Install $1!"
}

copyresolv(){
    $PRIV /usr/local/share/archbox/bin/copyresolv
}

asroot(){
    [[ $EUID -ne 0 ]] && err "Run this as root!"
}

#storeenv(){
#    echo $DBUS_SESSION_BUS_ADDRESS > /tmp/archbox_dbus_session_address
#    echo $XDG_RUNTIME_DIR > /tmp/archbox_xdg_runtime_dir
#}

storeenv() {
    echo "# This will be sourced when entering Archbox" > /tmp/archbox_env
    [[ ! -z $WAYLAND_DISPLAY ]] && echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" >> /tmp/archbox_env
    [[ ! -z $DISPLAY ]] && checkdep xhost && xhost +local: > /dev/null \
        && echo "DISPLAY=$DISPLAY" >> /tmp/archbox_env
    echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" >> /tmp/archbox_env
    echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >> /tmp/archbox_env
}

help_text(){
cat << EOF
USAGE: $0 <arguments>

OPTIONS:
  -c, --create URL      Creates a chroot enviroment.
  -e, --enter           Enters chroot enviroment.
  -h, --help            Displays this help message.
  --remount-run         Remount /run in chroot enviroment.
  --mount-runtime-only  Mount XDG_RUNTIME_DIR to chroot enviroment.

EOF
}

err(){
    echo "$(tput bold)$(tput setaf 1)==> $@ $(tput sgr0)" 1>&2
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
        while true; do wget -O archlinux.tar.gz $2 && break; done
        msg "Extracting the tarball..."
        checkdep tar
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
        /usr/local/share/archbox/bin/archboxinit start
        cp /usr/local/share/archbox/chroot_setup.bash $CHROOT/chroot_setup
        echo $USER > /tmp/archbox_user
        chroot $CHROOT /bin/bash -c "/chroot_setup"
        exit $?
    ;;
    -e|--enter)
        storeenv
        copyresolv
        $PRIV /usr/local/share/archbox/bin/archbox enter
        exit $?
    ;;
    --remount-run)
        $PRIV /usr/local/share/archbox/bin/remount_run
        exit $?
    ;;
    --mount-runtime-only)
        $PRIV /usr/local/share/archbox/bin/remount_run runtimeonly
        exit $?
    ;;
    -h|--help)
        help_text
        exit 0
    ;;
    "")
        help_text
        exit 1
    ;;
    -*)
        err "Unknown option: $1"
    ;;
    *)
        storeenv
        copyresolv
        $PRIV /usr/local/share/archbox/bin/archbox $@
        exit $?
    ;;
esac
