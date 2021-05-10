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
Just follow [INSTALL.md](INSTALL.md).
## Miscs
### Init Archbox Automatically
Add `archbox -m` to `~/.bashrc`.
### Uniform look with ChromeOS
Install [`cros-adapta-gtk-theme`](https://aur.archlinux.org/packages/cros-adapta-gtk-theme/) from AUR and set it with `lxappearance` and `dconf-editor`.