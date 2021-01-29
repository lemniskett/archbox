#!/usr/bin/env bash

source /etc/archbox.conf

checkdep(){
    hash $1 2>/dev/null || err "Install $1!"
}

copyresolv(){
    $PRIV $PREFIX/share/archbox/bin/copyresolv
}

asroot(){
    [[ $EUID -ne 0 ]] && err "Run this as root!"
}

storeenv() {
    echo "# This will be sourced when entering Archbox" > /tmp/archbox_env
    [[ ! -z $WAYLAND_DISPLAY ]] && echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" >> /tmp/archbox_env
    if [[ ! -z $DISPLAY ]]; then
        hash xhost >/dev/null 2>&1 && xhost +local: > /dev/null 
        echo "DISPLAY=$DISPLAY" >> /tmp/archbox_env
    fi
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
  -m, --mount           Mount Archbox directories.
  -u, --umount          Unmount Archbox directories.
  --remount-run         Remount /run in chroot enviroment.
  --mount-runtime-only  Mount XDG_RUNTIME_DIR to chroot enviroment.

EOF
}

fetch_tarball(){
    if hash aria2c 2>/dev/null; then
        aria2c -o archlinux.tar.gz $1
    elif hash wget 2>/dev/null; then
        wget -O archlinux.tar.gz $1
    elif hash curl 2>/dev/null; then
        curl -o archlinux.tar.gz $1
    else
        err "No supported downloader found."
    fi
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
        while true; do fetch_tarball $2 && break; done
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
        $PREFIX/share/archbox/bin/archboxinit start
        cp $PREFIX/share/archbox/chroot_setup.bash $CHROOT/chroot_setup
        echo $USER > /tmp/archbox_user
        chroot $CHROOT /bin/bash -c "/chroot_setup"
        exit $?
    ;;
    -e|--enter)
        storeenv
        copyresolv
        $PRIV $PREFIX/share/archbox/bin/archbox enter
        exit $?
    ;;
    -m|--mount)
        storeenv
        $PRIV $PREFIX/share/archbox/bin/archboxinit start
    ;;
    -u|--umount)
        storeenv
        $PRIV $PREFIX/share/archbox/bin/archboxinit stop
    ;;
    --remount-run)
        storeenv
        $PRIV $PREFIX/share/archbox/bin/remount_run
        exit $?
    ;;
    --mount-runtime-only)
        storeenv
        $PRIV $PREFIX/share/archbox/bin/remount_run runtimeonly
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
        $PRIV $PREFIX/share/archbox/bin/archbox $@
        exit $?
    ;;
esac
