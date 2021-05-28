#!/usr/bin/env bash

genconfig(){
    cat << EOF
ARCHBOX_USER="${ARCHBOX_USER:-root}"
PRIV="${PRIV:-sudo}"
INSTALL_PATH="${INSTALL_PATH:-/var/archlinux}"
CHROOT="${CHROOT:-\$INSTALL_PATH/root.x86_64}"

# Nix OS will breaks when you mount /run, change MOUNT_RUN to "no"
# if you use Nix OS, don't forget to use \`archbox --mount-runtime-only\`
# after user login.
MOUNT_RUN="${MOUNT_RUN:-yes}"

# Mount modules and boot directory, useful if you want to use kernels
# from Arch Linux repo, otherwise it's best to remain disabled.
MOUNT_MOD="${MOUNT_MOD:-no}"

# Lazy unmounting, make sure you know what you're doing if enabling this!
LAZY_UMOUNT="${LAZY_UMOUNT:-no}"

# Put your desired enviroment variable here, for example:
#
# ENV_VAR="HOME=/var/home/lemniskett"
#
ENV_VAR="${ENV_VAR:-}"

# Parse a Systemd service and executes it on boot, order matters, for example:
#
# SERVICES="vmware-networks-configuration vmware-networks vmware-usbarbitrator php-fpm:3 nginx"
#
# Keep in mind that this doesn't resolve service dependencies, so you may need to
# enable the dependencies manually.
SERVICES="${SERVICES:-}"

# Share other host directories into Archbox, absolute path needed.
SHARED_FOLDER="${SHARED_FOLDERS:-/home}"
EOF
}

ETC_DIR="${ETC_DIR:-/etc}"
PREFIX="${PREFIX:-/usr/local}"

mkdir -p $PREFIX/share/archbox/bin
mkdir -p $ETC_DIR
install -v -D -m 755 ./src/archbox $PREFIX/bin/archbox
install -v -D -m 755 ./src/archbox-desktop $PREFIX/bin/archbox-desktop
 [[ ! -e /etc/archbox.conf || ! -z $FORCE_INSTALL_CONFIG ]] && genconfig > $ETC_DIR/archbox.conf
install -v -D -m 755 ./src/exec $PREFIX/share/archbox/bin/exec
install -v -D -m 755 ./src/enter $PREFIX/share/archbox/bin/enter
install -v -D -m 755 ./src/chroot_setup $PREFIX/share/archbox/chroot_setup
install -v -D -m 755 ./src/init $PREFIX/share/archbox/bin/init
install -v -D -m 755 ./src/uth $PREFIX/share/archbox/bin/uth

grep 'PREFIX=' $ETC_DIR/archbox.conf >/dev/null 2>&1 || cat << EOF >> $ETC_DIR/archbox.conf

# Don't change this unless you know what you're doing.
PREFIX="$PREFIX"
EOF
[[ -z $1 ]] && exit 0

if [ $1 = "--exp" ]; then
	install -v -D -m 755 ./src/exp/startx-killxdg.bash $PREFIX/bin/startx-killxdg
else
	echo "Unknown install option: $1"
fi
