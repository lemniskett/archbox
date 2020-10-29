#!/bin/bash

source /etc/archbox.conf

ENV="$(cat /tmp/env_archbox)"
COMMAND=$(echo $@ | tr ' ' '\ ')
[[ $1 = "enter" ]] && chroot $CHROOT /sbin/env $ENV /bin/su $USER \
    || chroot $CHROOT /bin/su -c "env $ENV $COMMAND" $USER
