#!/bin/bash

source /etc/archbox.conf

case $1 in
	start)
		mount -R /home $CHROOT/home
		mount -t proc /proc $CHROOT/proc
		mount -R /tmp $CHROOT/tmp
		mount -R /sys $CHROOT/sys
		mount -R /dev $CHROOT/dev
		mount -R /run $CHROOT/run
		mount -R /lib/modules $CHROOT/lib/modules
		mount -R /boot $CHROOT/boot
		mount -R /var/lib/dbus $CHROOT/var/lib/dbus
		chroot $CHROOT /usr/local/bin/serviced >/dev/null 2>&1
		exit 0
	;;
	stop)
		umount -R $CHROOT/home
		umount -R $CHROOT/proc
		umount -R $CHROOT/tmp
		umount -R $CHROOT/sys
		umount -R $CHROOT/dev
		umount -R $CHROOT/run
		umount -R $CHROOT/lib/modules
		umount -R $CHROOT/boot
		umount -R $CHROOT/var/lib/dbus
		exit 0
	;;
esac
