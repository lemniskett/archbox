#!/bin/bash

source /etc/archbox.conf

mount -R /home $CHROOT/home
mount -t proc /proc $CHROOT/proc
mount -R /tmp $CHROOT/tmp
mount -R /sys $CHROOT/sys
mount -R /dev $CHROOT/dev
mount -R /run $CHROOT/run
mount -R /lib/modules $CHROOT/lib/modules
mount -R /boot $CHROOT/boot
mount -R /var/lib/dbus $CHROOT/var/lib/dbus
chroot $CHROOT /usr/local/bin/serviced
