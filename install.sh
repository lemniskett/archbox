#!/usr/bin/env bash

PREFIX="/usr/local"

mkdir -p $PREFIX/share/archbox/bin
install -v -D -m 755 ./archbox.bash $PREFIX/bin/archbox
install -v -D -m 755 ./archbox-desktop.bash $PREFIX/bin/archbox-desktop
[[ ! -e /etc/archbox.conf ]] && install -v -D -m 755 ./archbox.conf /etc/archbox.conf
install -v -D -m 755 ./archboxcommand.bash $PREFIX/share/archbox/bin/archbox
install -v -D -m 755 ./chroot_setup.bash $PREFIX/share/archbox/chroot_setup.bash
install -v -D -m 755 ./init.bash $PREFIX/share/archbox/bin/init
install -v -D -m 755 ./uth.bash $PREFIX/share/archbox/bin/uth

grep 'PREFIX=' /etc/archbox.conf >/dev/null 2>&1 || cat << EOF >> /etc/archbox.conf

# Don't change this unless you know what you're doing.
PREFIX="$PREFIX"
EOF
[[ -z $1 ]] && exit 0

if [ $1 = "--exp" ]; then
	install -v -D -m 755 ./exp/startx-killxdg.bash $PREFIX/bin/startx-killxdg
else
	echo "Unknown install option: $1"
fi
