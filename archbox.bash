#!/bin/bash

source /etc/archbox.conf

checkdep(){
    which $1 >/dev/null 2>&1 || echo "Install $1." && exit 1
}

copyresolv(){
    $PRIV /usr/local/share/archbox/bin/copyresolv
}

asroot(){
    [[ $EUID -ne 0 ]] && echo "Run this as root!" && exit 1
}

help_text(){
cat << EOF
USAGE $0 <arguments>
OPTIONS:
  --create LINK     Creates a chroot enviroment.
  --enter           Enters chroot enviroment.
  --help            Displays this help message.
EOF
}

case $1 in
    --create)
        asroot
        [[ -z $2 ]] && echo "Specify the link of Arch Linux bootstrap tarball." \
            && exit 1
        mkdir $INSTALL_PATH
        cd $INSTALL_PATH
        checkdep wget
        wget -q --show-progress -O archlinux.tar.gz $2
        tar xzf archlinux.tar.gz
        cp /etc/resolv.conf $CHROOT/etc/resolv.conf
        echo "You will need to edit which mirror you want to use, uncomment needed mirrors and save it."
        echo "Editor of your choice:"
        read MIRROR_EDITOR
        $MIRROR_EDITOR $CHROOT/etc/pacman.d/mirrorlist || exit 1
        checkdep wget
        echo "Disabling Pacman's CheckSpace"
        checkdep sed
        sed -i 's/CheckSpace/#CheckSpace/g' $CHROOT/etc/pacman.conf
        
        ;;
    --enter)
	    copyresolv
    	$PRIV /usr/local/share/archbox/bin/archboxenter
	;;
    --help)
        help_text
    ;;
    "")
        help_text
    ;;
    *)
    	copyresolv
        COMMAND=$(echo $@ | tr ' ' '\ ')
	    $PRIV /usr/local/share/archbox/bin/archboxcommand $COMMAND
    ;;
esac
