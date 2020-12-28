#!/usr/bin/env bash

source /etc/archbox.conf

case $1 in
	start)
		mount -R /home $CHROOT/home
		mount -t proc /proc $CHROOT/proc
		mount -R /tmp $CHROOT/tmp
		mount -R /sys $CHROOT/sys
		mount --make-rslave $CHROOT/sys
		mount -R /dev $CHROOT/dev
		mount --make-rslave $CHROOT/dev
		[[ $MOUNT_RUN = "yes" ]] && mount -R /run $CHROOT/run
		mount -R /lib/modules $CHROOT/lib/modules
		mount -R /boot $CHROOT/boot
		mount -R /var/lib/dbus $CHROOT/var/lib/dbus
		mount -R / $CHROOT/var/host
		chroot $CHROOT /usr/local/bin/serviced >/dev/null 2>&1
		exit 0
	;;
	stop)
		umount -R $CHROOT/home
		umount -R $CHROOT/proc
		umount -R $CHROOT/tmp
		umount -R $CHROOT/sys
		umount -R $CHROOT/dev
		[[ $MOUNT_RUN = "yes" ]] && umount -R $CHROOT/run
		umount -R $CHROOT/lib/modules
		umount -R $CHROOT/boot
		umount -R $CHROOT/var/lib/dbus
		umount -R $CHROOT/var/host
		exit 0
	;;
esac
