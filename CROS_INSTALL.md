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
## Miscs
### Init Archbox Automatically
Add `archbox -m` to `~/.bashrc`.
### Uniform look with ChromeOS
Install [`cros-adapta-gtk-theme`](https://aur.archlinux.org/packages/cros-adapta-gtk-theme/) from AUR and set it with `lxappearance` and `dconf-editor`.