#!/bin/bash

source /etc/archbox.conf

DBUS_ADDRESS_ENV="$(cat /tmp/archbox_dbus_session_address)"
XDG_RUNTIME_ENV="$(cat /tmp/archbox_xdg_runtime_dir)"
COMMAND=$(echo $@ | tr ' ' '\ ')
[[ $1 = "enter" ]] && chroot $CHROOT /sbin/env DBUS_SESSION_BUS_ADDRESS=$DBUS_ADDRESS_ENV XDG_RUNTIME_DIR=$XDG_RUNTIME_ENV /bin/su $USER \
    || chroot $CHROOT /bin/su -c "env DBUS_SESSION_BUS_ADDRESS=$DBUS_ADDRESS XDG_RUNTIME_DIR=$XDG_RUNTIME_ENV $COMMAND" $USER
