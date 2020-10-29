#!/bin/bash

source /etc/archbox.conf

DBUS_ADDRESS="$(cat /tmp/archbox_dbus_session_address)"
COMMAND=$(echo $@ | tr ' ' '\ ')
[[ $1 = "enter" ]] && chroot $CHROOT /sbin/env DBUS_SESSION_BUS_ADDRESS=$DBUS_ADDRESS /bin/su $USER \
    || chroot $CHROOT /bin/su -c "env DBUS_SESSION_BUS_ADDRESS=$DBUS_ADDRESS $COMMAND" $USER
