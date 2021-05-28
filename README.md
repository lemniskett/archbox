# Archbox
Installs Arch Linux inside a chroot environment.
## Why?
Ever since I'm running some niche distros like Void, Solus, I had a problem finding softwares I need in their not-so-large repositories, also I don't like how flatpak and snap works. so i decided to create an Arch Linux chroot environment everytime I distrohop. Why Arch Linux? They have a really, really good repositories, oh and don't mention how big AUR is.
## Installation
See [INSTALL.md](INSTALL.md)

For NixOS users, [NIXOS_INSTALL.md](NIXOS_INSTALL.md)

For ChromeOS users, [CROS_INSTALL.md](CROS_INSTALL.md)
## Using Archbox
### Installing chroot environment
Before creating chroot environment, edit your chroot username in ```/etc/archbox.conf```, then do :
```
sudo archbox --create <archlinux tarball download link>
```
### Configuring filesystem automount
Execute ```archbox --mount``` on boot.
If you use systemd, you can create a systemd service with this syntax below (Assuming the install prefix is ```/usr/local```) :
```
[Unit]
Description=Archbox init
PartOf=multi-user.target

[Service]
ExecStart=/usr/local/share/archbox/bin/init start
Type=oneshot
User=root

[Install]
WantedBy=multi-user.target
```
Thanks to [@SamsiFPV](https://github.com/SamsiFPV)

If you don't use systemd, either create your own init service, or create a @reboot cronjob :
```
@reboot /usr/local/share/archbox/bin/init start
```
### Removing chroot environment
**IMPORTANT**, Make sure you've unmounted everything in chroot environment, it's better to remove the init script and reboot to unmount everything. if you can't reboot for some reason, do :
```
archbox -u
```
then do (Assuming the INSTALL_PATH is /var/archlinux) :
```
mount | grep /var/archlinux
```
make sure there's no mounted Archbox directories and then delete the Arch Linux directory :
```
rm -rf /var/archlinux
```
### Entering chroot environment
To enter chroot, do :
```
archbox --enter
```
### Executing commands in chroot environment
To execute commands inside chroot environment, do :
```
archbox <command>
```
for example, to update chroot, do :
```
archbox sudo pacman -Syu
```
### Optional steps
You may want to add these rules if you want to use Archbox without password (assuming the install prefix is ```/usr/local``` and you're in group ```wheel```) :
#### Sudo
```
%wheel  ALL=(root) NOPASSWD: /usr/local/share/archbox/bin/enter,/usr/local/share/archbox/bin/exec,/usr/local/share/archbox/bin/uth,/usr/local/share/archbox/bin/init
```
#### Doas
```
permit nopass :wheel as root cmd /usr/local/share/archbox/bin/enter
permit nopass :wheel as root cmd /usr/local/share/archbox/bin/exec
permit nopass :wheel as root cmd /usr/local/share/archbox/bin/uth
permit nopass :wheel as root cmd /usr/local/share/archbox/bin/init
```
### Misc
#### Systemd services
Use ```archboxctl``` command to manage systemd services.
More info [here](https://github.com/lemniskett/archboxctl).

This isn't actually using systemd to start services, rather it parses systemd .service files and executes it.

##### Autostart services
To enable service on host boot, edit `/etc/archbox.conf` :
```
SERVICES="vmware-networks-configuration vmware-networks vmware-usbarbitrator nginx"
```
Keep in mind that this doesn't resolve service dependencies, so you may need to enable the dependencies manually. you can use ```archboxctl desc <service>``` to read the .service file

##### Post-exec delay
Services are asynchronously started, if some services have some issues when starting together you may want to add post-exec delay.
```
SERVICES="php-fpm:3 nginx"
```

This will add 3 seconds delay after executing php-fpm.
##### Start services immediately
To start services immediately, in Archbox, do :
```
sudo archboxctl exec <Service name>
```

##### Custom command on boot
You can create a shell script located at ```/etc/archbox.rc``` and ```archboxinit``` will execute it in Archbox on boot.

#### Desktop entries
Use ```archbox-desktop``` to install desktop entries in chroot to host (installed to ```~/.local/share/applications/archbox```), you'll need to add ```sudo``` (or ```doas```) rules to launch archbox without a password.
#### Lauching apps via rofi
Instead of opening terminal or installing desktop entries everytime you want to run application inside chroot, you may want to launch rofi inside chroot, install rofi and do :
```
archbox rofi -show drun
```
Just like desktop entries, you'll need to add ```sudo``` (or ```doas```) rules to launch archbox without a password.
#### Prompt
If you use bash with nerd font you could add a nice little Arch Linux icon in your prompt, add :
```
[[ -e /etc/arch-release ]] && export PS1=" $PS1"
```
to your ```~/.bashrc```
#### Adding environment variables
Edit ENV_VAR in ```/etc/archbox.conf```. For example, if you want to use qt5ct as Qt5 theme, edit it like this :
```
ENV_VAR="QT_QPA_PLATFORMTHEME=qt5ct"
```
An example with multiple environment variables.
```
ENV_VAR="QT_QPA_PLATFORMTHEME=qt5ct GTK_CSD=0 LD_PRELOAD=/var/home/lemniskett/git_repo/gtk3-nocsd/libgtk3-nocsd.so.0"
```

#### Adding more shared directories
Edit SHARED_FOLDER in ```/etc/archbox.conf```. For example: 
```
SHARED_FOLDER=( /home /var/www )
```
To mount to different directory, use ```:``` separator :
```
SHARED_FOLDER=( /home /var/www:/host_webroot )
```
### Known issues
#### NixOS-specific issues
##### /run mounting
Mounting ```/run``` somehow breaks NixOS, set ```MOUNT_RUN``` in ```/etc/archbox.conf``` to anything other than ```yes``` to disable mounting ```/run```, then do :
```
archbox --mount-runtime-only
```
after user login to make XDG runtime directory accessible to chroot enviroment. make sure dbus unix:path is in XDG runtime directory too.
```
$ echo $XDG_RUNTIME_DIR
/run/user/1000
$ echo $DBUS_SESSION_BUS_ADDRESS
unix:path=/run/user/1000/bus
```
Or alternatively if you use WM-only, just disable mounting ```/run``` entirely and manually set XDG_RUNTIME_DIR into ```/tmp``` like ```/tmp/$(whoami)```, this is not recommended if you use systemd, stuffs like Pipewire, Desktop portal, etc may broke.

##### Archbox didn't access resources in /usr/share
In Archbox, Symlink ```/usr``` to ```/run/current-system/sw```:
```
sudo mkdir -p /run/current-system
sudo ln -s /usr /run/current-system/sw
```
make sure /run isn't mounted.

##### Archbox didn't recognize commands
Add ```PATH``` variable to ```/etc/archbox.conf```, for example:
```
ENV_VAR="PATH=/usr/bin:/usr/local/bin"
```

#### PulseAudio refused to connect
This can be caused by different dbus machine-id between chroot and host, copying ```/etc/machine-id``` from host to chroot should do the job.
#### XDG_RUNTIME_DIR is not visible in Archbox
Although /run is mounted in chroot environment on boot, XDG_RUNTIME_DIR sometimes is not visible in chroot environment, remounting /run will make it visible. do :
```
archbox --remount-run
```
after user login, And sometimes you need to kill every process that runs in XDG_RUNTIME_DIR when you log out, You need to reinstall archbox with ```--exp``` flag and use ```startx-killxdg``` instead of ```startx```, or run :
```
/usr/local/share/archbox/bin/uth killxdg
```
on logout. you can put it in ```/etc/gdm/PostSession/Default``` if you use GDM, or just disable mounting ```/run``` entirely, set ```MOUNT_RUN``` in ```/etc/archbox.conf``` to anything other than ```yes``` to disable mounting ```/run``` and do :
```
archbox --remount-run
```
after user login.

#### Polkit
```pkexec``` is kind of tricky to make it work in chroot, if you use rofi to launch GUI applications in chroot, you may not able to launch any ```.desktop``` files with ```Exec=pkexec...``` in it. If you really want them to work, you can do :
```
sudo ln -sf /usr/bin/sudo /usr/bin/pkexec
```
in chroot and prevent pacman from restoring ```/usr/bin/pkexec``` by editing ```NoExtract``` in ```/etc/pacman.conf```.

#### No sudo password in chroot by default.
You could use ```sudo``` in archbox, but you'll have no way to enter the password when doing e.g. ```archbox sudo pacman -Syu```. also you could enter the password if you do ```archbox -e < <(echo $COMMAND)```, but that would disable stdin entirely during $COMMAND.
