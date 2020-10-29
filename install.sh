#!/bin/bash

mkdir -p /usr/local/share/archbox/bin
cp -v ./archbox.bash /usr/local/bin/archbox
[[ ! -e /etc/archbox.conf ]] && cp -v ./archbox.conf /etc/archbox.conf
cp -v ./copyresolv.bash /usr/local/share/archbox/bin/copyresolv
cp -v ./archboxcommand.bash /usr/local/share/archbox/bin/archbox
cp -v ./chroot_setup.bash /usr/local/share/archbox/chroot_setup.bash
