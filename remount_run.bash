#!/usr/bin/env bash

source /etc/archbox.conf

case $1 in 
	killxdg)
	umount -l $CHROOT/run
	fuser -km $(cat /tmp/archbox_xdg_runtime_dir)
	exit $?
	;;
	runtimeonly)
	mkdir -p $CHROOT/$(cat /tmp/archbox_xdg_runtime_dir)
	umount -Rl $CHROOT/$(cat /tmp/archbox_xdg_runtime_dir)
	mount --rbind $(cat /tmp/archbox_xdg_runtime_dir) $CHROOT/$(cat /tmp/archbox_xdg_runtime_dir)
	exit $?
	;;
	*)
        umount -l $CHROOT/run
	mount --rbind /run $CHROOT/run
	exit $?
	;;
esac
