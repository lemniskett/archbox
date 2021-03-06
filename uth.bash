#!/usr/bin/env bash

source /etc/archbox.conf
source /tmp/archbox_env

case $1 in
    copyresolv)        
        cp /etc/resolv.conf $CHROOT/etc/resolv.conf
        ;;
    killxdg)
        umount -l $CHROOT/run
        fuser -km $XDG_RUNTIME_DIR
        exit $?
        ;;
    runtimeonly)
        mkdir -p $CHROOT$XDG_RUNTIME_DIR
        umount -Rl $CHROOT$XDG_RUNTIME_DIR 2>/dev/null
        mount | grep $CHROOT$XDG_RUNTIME_DIR || \
            mount --rbind $XDG_RUNTIME_DIR $CHROOT$XDG_RUNTIME_DIR
        exit $?
        ;;
    remountrun)
        umount -l $CHROOT/run 2>/dev/null
        mount --rbind /run $CHROOT/run
        exit $?
        ;;
esac