#!/bin/sh

mkdir -p /usr/local/share/archbox/bin
cp -v ./archbox.bash /usr/local/bin/archbox
cp -v ./archbox.conf /etc/archbox.conf
cp -v ./archboxenter.bash /usr/local/share/archbox/bin/archboxenter
cp -v ./copyresolv.bash /usr/local/share/archbox/bin/copyresolv
cp -v ./archboxcommand.bash /usr/local/share/archbox/bin/archboxcommand
cp -v ./chroot_setup.bash /usr/local/share/archbox/chroot_setup.bash
