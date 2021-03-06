#!/usr/bin/env bash
source /etc/archbox.conf

case $1 in
    copyresolv)        
        cp /etc/resolv.conf $CHROOT/etc/resolv.conf
        ;;
esac