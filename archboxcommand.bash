#!/bin/bash

source /etc/archbox.conf

COMMAND=$(echo $@ | tr ' ' '\ ')
[[ ! $1 = "--enter" ]] && chroot $CHROOT /bin/su -c "$COMMAND" $USER \
    || chroot $CHROOT /bin/su $USER
