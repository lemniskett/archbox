#!/usr/bin/env bash

source /etc/archbox.conf

msg(){
    echo "$(tput bold)$(tput setaf 2)==> $@ $(tput sgr0)"
}

rbind() {
    [[ $(mount | grep $CHROOT$1) ]] && msg "$CHROOT$1 already mounted." \
        || (mount -R $1 $CHROOT$1 && msg "$CHROOT$1 mounted!")
    [[ $2 = "make-rslave" ]] && mount --make-rslave $CHROOT$1
}

bindproc() {
    [[ $(mount | grep $CHROOT/proc) ]] && msg "$CHROOT already mounted." \
        || (mount -t proc /proc $CHROOT/proc && msg "$CHROOT/proc mounted!")
}

rmbind() {
    umount_args=-R
    [[ $LAZY_UMOUNT = "yes" ]] && umount_args=-Rl
    [[ $(mount | grep $CHROOT$1) ]] && umount $umount_args $CHROOT$1 \
        && msg "$CHROOT$1 unmounted!"
}

case $1 in
    start)
        rbind /home
        bindproc
        rbind /tmp
        rbind /sys make-rslave
        rbind /dev make-rslave
        [[ $MOUNT_RUN = "yes" ]] && rbind /run
        [[ $MOUNT_MOD = "yes" ]] && rbind /lib/modules && rbind /boot
        [[ -d /var/lib/dbus ]] && rbind /var/lib/dbus
        chroot $CHROOT /usr/local/bin/serviced >/dev/null 2>&1
        exit 0
    ;;
    stop)
        rmbind /home
        rmbind /proc
        rmbind /tmp
        rmbind /sys
        rmbind /dev
        [[ $MOUNT_RUN = "yes" ]] && rmbind /run
        [[ $MOUNT_MOD = "yes" ]] && rmbind /lib/modules && rmbind /boot
        rmbind /var/lib/dbus
        kill $(pidof serviced) 2>/dev/null
        exit 0
    ;;
esac
