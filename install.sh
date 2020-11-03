#!/bin/bash

mkdir -p /usr/local/share/archbox/bin
install -v -D -m 755 ./archbox.bash /usr/local/bin/archbox
[[ ! -e /etc/archbox.conf ]] && install -v -D -m 755 ./archbox.conf /etc/archbox.conf
install -v -D -m 755 ./copyresolv.bash /usr/local/share/archbox/bin/copyresolv
install -v -D -m 755 ./archboxcommand.bash /usr/local/share/archbox/bin/archbox
install -v -D -m 755 ./remount_run.bash /usr/local/share/archbox/bin/remount_run
install -v -D -m 755 ./chroot_setup.bash /usr/local/share/archbox/chroot_setup.bash

[[ -z $1 ]] && exit 0

if [ $1 = "--exp" ]; then
	install -v -D -m 755 ./exp/startx-killxdg.bash /usr/local/bin/startx-killxdg
else
	echo "Unknown install option: $1"
fi
