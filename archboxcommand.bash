#!/usr/bin/env bash

source /etc/archbox.conf

REQ_ENV="DBUS_SESSION_BUS_ADDRESS=$(cat /tmp/archbox_dbus_session_address) XDG_RUNTIME_DIR=$(cat /tmp/archbox_xdg_runtime_dir)"

ENV="$REQ_ENV $ENV_VAR"
COMMAND="$@"
[[ $1 = "enter" ]] && (chroot $CHROOT /sbin/env $ENV /bin/su $USER; exit 0) \
    || chroot $CHROOT /bin/su -c "env $ENV $COMMAND" $USER
