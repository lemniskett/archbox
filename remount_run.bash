#!/bin/bash

source /etc/archbox.conf

umount -l $CHROOT/run
mount --rbind /run $CHROOT/run
