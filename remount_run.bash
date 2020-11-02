#!/bin/bash

source /etc/archbox.conf

case $1 in 
	killxdg)
	umount -l $CHROOT/run
	fuser -km $(cat /tmp/archbox_xdg_runtime_dir)
	;;
	*)
        umount -l $CHROOT/run
	mount --rbind /run $CHROOT/run
	;;
esac
