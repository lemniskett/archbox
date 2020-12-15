#!/bin/bash

source /etc/archbox.conf

install_desktop(){
    mkdir -p ~/.local/share/applications/archbox
    for i in $@; do
        archbox readlink /usr/share/applications/$i >/dev/null 2>&1 \
            && cp $CHROOT/$(archbox readlink /usr/share/applications/$i) ~/.local/share/applications/archbox \
            || cp $CHROOT/usr/share/applications/$i ~/.local/share/applications/archbox 
        sed -i 's/Exec=/Exec=archbox\ /g' ~/.local/share/applications/archbox/$i
    done
}

help_text(){
cat << EOF
USAGE: $0 <arguments>

OPTIONS:
  -i, --install URL     Installs a desktop entry in /usr/share/applications
  -h, --help            Displays this help message

EOF
}

case $1 in 
    -i|--install)
        install_desktop ${@:2}
    ;;
    -h|--help)
        help_text
    ;;
    *)
        list_desktop="$(archbox ls --color=none -1 /usr/share/applications)"
        zenity_entry="$(echo $list_desktop | sed 's/\ /\ FALSE\ /g')"
        selected_entry=$(zenity --list --checklist --height=500 --width=450 \
        --title="Archbox Desktop Manager" \
        --text "Select .desktop entries those you want to install" \
        --column "Select" --column "Applications" \
        FALSE $zenity_entry | sed 's/|/\ /g')
        install_desktop $selected_entry
    ;;
esac    