# Installation (ChromeOS)
## Prerequisites
- Enabled developer mode
## Installing dependencies
We'll install needed dependencies with chromebrew, head over to [chromebrew installation guide](https://github.com/skycocker/chromebrew#installation) and do :
```sh
crew install sommelier wget 
crew install llvm # OPTIONAL: needed for AMD GPUs
source ~/.bashrc
```
## Installing Archbox
Just follow [INSTALL.md](INSTALL.md) but with :
1. Now that `/usr/local` is owned by you, it's better to set `INSTALL_PATH` to somewhere in `/usr/local` in `archbox.conf`, for example `/usr/local/archbox`
2. Remove `/home` from `SHARED_FOLDER` in `archbox.conf`

Then add :
```sh
[[ $DBUS_SESSION_BUS_ADDRESS = "disabled:" ]] && eval "$(dbus-launch)"
```
to `~/.bashrc` in Archbox
## Miscs
### Init Archbox Automatically
Add `archbox -m` to `~/.bashrc` in host.
### Uniform look with ChromeOS
Install [`cros-adapta-gtk-theme`](https://aur.archlinux.org/packages/cros-adapta-gtk-theme/), `ttf-roboto`, and `papirus-icon-theme` and use it with :
```sh
gsettings set org.gnome.desktop.interface gtk-theme "cros-adapta"
gsettings set org.gnome.desktop.interface icon-theme "Papirus-Light"
gsettings set org.gnome.desktop.interface font-name "Roboto 10"
```

For GTK2 apps, use `lxappearance` and for QT5 apps, use `qt5ct`

## Issues
### DBus
Things that depends on `dbus` may broke if you execute it directly, e.g. :
```
archbox dconf-editor
```
You'll need to enter the shell to use it.

### Audio
Audio doesn't seem to work at the moment, It's possible to start pulseaudio in chroot, but I didn't dive enough yet.
