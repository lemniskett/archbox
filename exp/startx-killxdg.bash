#!/bin/bash

source /etc/archbox.conf

startx
$PRIV /usr/local/share/archbox/bin/remount_run killxdg
