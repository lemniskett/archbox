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

rbind_diff() {
    [[ $(mount | grep $CHROOT$2) ]] && msg "$CHROOT$2 already mounted." \
        || (mount -R $1 $CHROOT$2 && msg "$CHROOT$2 mounted!")
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
        if [[ $MOUNT_MOD = "yes" ]]; then
            rbind $(readlink -f /lib/modules)
            rbind /boot
        fi
        [[ -d /var/lib/dbus ]] && rbind /var/lib/dbus
        for i in ${SHARED_FOLDER[@]}; do
            if [[ $i = *:* ]]; then
                source=$(echo $i | sed 's/:.*//')
                target=$(echo $i | sed 's/.*://')
                mkdir -p $CHROOT$target
                rbind_diff $source $target;
            else
                rbind $i;
            fi
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
        if [[ -e /etc/archbox.rc ]]; then
            cp /etc/archbox.rc /tmp/archbox.rc
            chmod +x /tmp/archbox.rc
            chroot $CHROOT /bin/su -c '/tmp/archbox.rc' > /tmp/archbox.rc.log 2>&1
            rm /tmp/archbox.rc
        fi
        exit 0
    ;;
    stop)
        rmbind /proc
        rmbind /tmp
        rmbind /sys
        rmbind /dev
        [[ $MOUNT_RUN = "yes" ]] && rmbind /run
        if [[ $MOUNT_MOD = "yes" ]]; then
            rmbind $(readlink -f /lib/modules)
            rmbind /boot
        fi
        rmbind /var/lib/dbus
        for i in ${SHARED_FOLDER[@]}; do
            if [[ $i = *:* ]]; then
                target=$(echo $i | sed 's/.*://')
                rmbind $target;
            else
                rmbind $i;
            fi
        done
        exit 0
    ;;
esac
