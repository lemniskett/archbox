#!/usr/bin/env bash

ETC_DIR="${ETC_DIR:-/etc}"
PREFIX="${PREFIX:-/usr/local}"

mkdir -p $PREFIX/share/archbox/bin
install -v -D -m 755 ./src/archbox.bash $PREFIX/bin/archbox
install -v -D -m 755 ./src/archbox-desktop.bash $PREFIX/bin/archbox-desktop
 [[ ! -e /etc/archbox.conf || ! -z $FORCE_INSTALL_CONFIG ]] && ./genconfig.sh > $ETC_DIR/archbox.conf
install -v -D -m 755 ./src/exec.bash $PREFIX/share/archbox/bin/exec
install -v -D -m 755 ./src/enter.bash $PREFIX/share/archbox/bin/enter
install -v -D -m 755 ./src/chroot_setup.bash $PREFIX/share/archbox/chroot_setup.bash
install -v -D -m 755 ./src/init.bash $PREFIX/share/archbox/bin/init
install -v -D -m 755 ./src/uth.bash $PREFIX/share/archbox/bin/uth

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
