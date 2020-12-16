#!/bin/bash

source /etc/archbox.conf

install_desktop(){
    mkdir -p ~/.local/share/applications/archbox
    for i in $@; do
        archbox readlink /usr/share/applications/$i >/dev/null 2>&1 \
            && cp $CHROOT/$(archbox readlink /usr/share/applications/$i) ~/.local/share/applications/archbox \
            || cp $CHROOT/usr/share/applications/$i ~/.local/share/applications/archbox 
        sed -i 's/Exec=/Exec=archbox\ /g' ~/.local/share/applications/archbox/$i
        sed -1 '/TryExec=/d' ~/.local/share/applications/archbox/$i
    done
}

checkdep(){
    which $1 >/dev/null 2>&1 || err "Install $1!"
}

err(){
    echo "$(tput bold)$(tput setaf 1)==> $@ $(tput sgr0)"
    exit 1
}

help_text(){
cat << EOF
USAGE: $0 <arguments>

OPTIONS:
  -i, --install FILE    Installs desktop entries in /usr/share/applications
  -r, --remove FILE     Removes desktop entries in ~/.local/share/applications/archbox
  -l, --list            List available desktop entries
  -s, --list-installed  List installed desktop entries
  -h, --help            Displays this help message

EOF
}

case $1 in 
    -i|--install)
        install_desktop ${@:2}
        ;;
    -r|--remove)
        eval rm ~/.local/share/applications/archbox/{$selected_entry}
        ;;
    -h|--help)
        help_text
        ;;
    -l|--list)
        archbox ls -1 --color=none /usr/share/applications
        ;;
    -s|--list-installed)
        ls -1 --color=none ~/.local/share/applications/archbox
        ;;
    *)
        checkdep zenity
        checkdep sed
        action="$(zenity --list --radiolist --title 'Archbox Desktop Manager' \
            --height=200 --width=450 --column 'Select' --column 'Action' \
            --text 'What do you want to do?' \
             FALSE 'Install desktop entries' FALSE 'Remove desktop entries')"
        case $action in
            'Install desktop entries')
                list_desktop="$(archbox ls --color=none -1 /usr/share/applications)"
                zenity_entry="$(echo $list_desktop | sed 's/\ /\ FALSE\ /g')"
                selected_entry=$(zenity --list --checklist --height=500 --width=450 \
                --title="Archbox Desktop Manager" \
                --text "Select .desktop entries those you want to install" \
                --column "Select" --column "Applications" \
                FALSE $zenity_entry | sed 's/|/\ /g')
                [[ -z $selected_entry ]] && exit 1
                install_desktop $selected_entry
                exit 0
                ;;
            'Remove desktop entries')
                list_desktop="$(ls --color=none -1 ~/.local/share/applications/archbox)"
                [[ -z $list_desktop ]] && zenity --info --title "Archbox Desktop Manager" \
                    --text "No .desktop files installed" --width=300 && exit 1
                zenity_entry="$(echo $list_desktop | sed 's/\ /\ FALSE\ /g')"
                selected_entry=$(zenity --list --checklist --height=500 --width=450 \
                --title="Archbox Desktop Manager" \
                --text "Select .desktop entries those you want to remove" \
                --column "Select" --column "Applications" \
                FALSE $zenity_entry | sed 's/|/\,/g')
                [[ -z $selected_entry ]] && exit 1
                eval rm ~/.local/share/applications/archbox/{$selected_entry}
                exit $?
                ;;
        esac
        exit 1
    ;;
esac    