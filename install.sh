#!/bin/bash

mkdir -p /usr/local/share/archbox/bin
install -v -D -m 755 ./archbox.bash /usr/local/bin/archbox
[[ ! -e /etc/archbox.conf ]] && install -v -D -m 755 ./archbox.conf /etc/archbox.conf
install -v -D -m 755 ./copyresolv.bash /usr/local/share/archbox/bin/copyresolv
install -v -D -m 755 ./archboxcommand.bash /usr/local/share/archbox/bin/archbox
install -v -D -m 755 ./chroot_setup.bash /usr/local/share/archbox/chroot_setup.bash
