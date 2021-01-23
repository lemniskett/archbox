#!/bin/bash

source /etc/archbox.conf

startx
$PRIV $PREFIX/share/archbox/bin/remount_run killxdg
