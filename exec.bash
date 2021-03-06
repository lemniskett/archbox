#!/usr/bin/env bash

source /etc/archbox.conf
source /tmp/archbox_env

REQ_ENV="DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS "
REQ_ENV+="XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR "
[[ ! -z $DISPLAY ]] && REQ_ENV+="DISPLAY=$DISPLAY "
[[ ! -z $WAYLAND_DISPLAY ]] && REQ_ENV+="WAYLAND_DISPLAY=$WAYLAND_DISPLAY "

ENV="$REQ_ENV $ENV_VAR"
COMMAND="$@"
[[ $1 = "enter" ]] && (chroot $CHROOT /sbin/env $ENV /bin/su $USER; exit 0) \
    || chroot $CHROOT /bin/su -c "env $ENV $COMMAND" $USER
