#!/bin/bash

source /etc/archbox.conf
COMMAND=$(echo $@ | tr ' ' '\ ')
chroot $CHROOT /bin/su -c "$COMMAND" $USER