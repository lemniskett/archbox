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
    [[ $(mount | grep $CHROOT/proc) ]] && msg "$CHROOT/proc already mounted." \
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
        bindproc
        rbind /tmp
        rbind /sys make-rslave
        rbind /dev make-rslave
        [[ $MOUNT_RUN = "yes" ]] && rbind /run
        [[ $MOUNT_MOD = "yes" ]] && rbind /lib/modules && rbind /boot
        [[ -d /var/lib/dbus ]] && rbind /var/lib/dbus
        for i in ${SHARED_FOLDER[@]}; do
            mkdir -p $CHROOT/$i
            rbind $i
        done
        msg "Starting services"
        for j in ${SERVICES[@]}; do
            if [[ $j = *:* ]]; then
                delay=$(echo $j | sed 's/.*://')
                service=$(echo $j | sed 's/:.*//')
                chroot $CHROOT /bin/su -c "/usr/local/bin/archboxctl exec $service" > /dev/null 2>&1 &
                sleep $delay
            else
                chroot $CHROOT /bin/su -c "/usr/local/bin/archboxctl exec $j" > /dev/null 2>&1 &
            fi
        done
        exit 0
    ;;
    stop)
        rmbind /proc
        rmbind /tmp
        rmbind /sys
        rmbind /dev
        [[ $MOUNT_RUN = "yes" ]] && rmbind /run
        [[ $MOUNT_MOD = "yes" ]] && rmbind /lib/modules && rmbind /boot
        rmbind /var/lib/dbus
        for i in ${SHARED_FOLDER[@]}; do
            rmbind $i
        done
        exit 0
    ;;
esac
