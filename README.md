# Archbox
Installs Arch Linux inside a chroot enviroment
## Why?
Ever since I'm running some niche distros like Void, Solus, I had a problem finding what softwares I need in their not-so-large repositories, also I don't like how flatpak and snap works. so i decided to create an Arch Linux chroot enviroment everytime I distrohop. Why Arch Linux? They have a really, really good repositories, oh and don't mention how big AUR is.
## Setup
It's pretty easy, just run ```install.sh``` as root
### Optional steps
You may want to add this, if you don't want to run archbox chroot without password:
#### Sudo
```%wheel  ALL=(root)      NOPASSWD: /usr/local/share/archbox/bin/archboxenter,/usr/local/share/archbox/bin/copyresolv,/usr/local/share/archbox/bin/archboxcommand```
#### Doas
```Idk you're on your own```
