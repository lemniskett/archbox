# Archbox
Installs Arch Linux inside a chroot enviroment.
## Why?
Ever since I'm running some niche distros like Void, Solus, I had a problem finding softwares I need in their not-so-large repositories, also I don't like how flatpak and snap works. so i decided to create an Arch Linux chroot enviroment everytime I distrohop. Why Arch Linux? They have a really, really good repositories, oh and don't mention how big AUR is.
## Installation
### Installing Archbox
It's pretty easy, just run ```install.sh``` as root.
### Installing chroot enviroment
Before creating chroot enviroment, edit your username in ```/etc/archbox.conf```, then do :
```
sudo archbox --create <archlinux tarball download link>
```
### Entering chroot enviroment
To enter chroot, do :
```
archbox --enter
```
### Executing commands in chroot enviroment
To execute commands inside chroot envirotment, do :
```
archbox <command>
```
for example, to update chroot, do :
```
archbox sudo pacman -Syu
```
### Automount filesystem
If you use runit, copy archbox folder inside ```runit/``` to whatever your distro store runit services and symlink it to whatever your distro store running runit services, if you don't use runit, you may need to create your own init script, or create a cronjob that runs on boot.
### Optional steps
You may want to add this, if you don't want to run archbox chroot without password :
#### Sudo
```
%wheel  ALL=(root)      NOPASSWD: /usr/local/share/archbox/bin/archboxenter,/usr/local/share/archbox/bin/copyresolv,/usr/local/share/archbox/bin/archboxcommand
```
#### Doas
```
Idk you're on your own
```
### Misc
#### Lauching apps via rofi
Instead of opening terminal everytime you want to run application inside chroot, you may want to launch rofi inside chroot, install rofi and do :
```
archbox rofi <rofi options>
```
#### Prompt
If you use bash with nerd font you could add a nice little Arch Linux icon in your prompt, add "
```
[[ -e /etc/arch-release ]] && export PS1=" $PS1"
```
to your ```~/.bashrc```
#### Adding enviroment variables
Edit ENV_VAR in ```/etc/archbox.conf```. For example, if you want to use /var/home/lemniskett as home directory, edit it like this :
```
ENV_VAR="QT_QPA_PLATFORMTHEME=qt5ct"
```
