#!/bin/bash

source /etc/archbox.conf
echo executing $@
chroot $CHROOT /bin/su -c $@ $USER