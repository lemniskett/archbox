#!/usr/bin/env bash

cat << EOF
ARCHBOX_USER="${ARCHBOX_USER:-root}"
PRIV="${PRIV:-sudo}"
INSTALL_PATH="${INSTALL_PATH:-/var/archlinux}"
CHROOT="${CHROOT:-\$INSTALL_PATH/root.x86_64}"

# Nix OS will breaks when you mount /run, change MOUNT_RUN to "no"
# if you use Nix OS, don't forget to use \`archbox --mount-runtime-only\`
# after user login.
MOUNT_RUN="${MOUNT_RUN:-yes}"

# Mount modules and boot directory, useful if you want to use kernels
# from Arch Linux repo, otherwise it's best to remain disabled.
MOUNT_MOD="${MOUNT_MOD:-no}"

# Lazy unmounting, make sure you know what you're doing if enabling this!
LAZY_UMOUNT="${LAZY_UMOUNT:-no}"

# Put your desired enviroment variable here, for example:
#
# ENV_VAR="HOME=/var/home/lemniskett"
#
ENV_VAR="${ENV_VAR:-}"

# Parse a Systemd service and executes it on boot, order matters, for example:
#
# SERVICES=( vmware-networks-configuration vmware-networks vmware-usbarbitrator php-fpm:3 nginx )
#
# Keep in mind that this doesn't resolve service dependencies, so you may need to
# enable the dependencies manually.
SERVICES=( ${SERVICES:-} )

# Share other host directories into Archbox, absolute path needed.
SHARED_FOLDER=( ${SHARED_FOLDERS:-/home} )
EOF