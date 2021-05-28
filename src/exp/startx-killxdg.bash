#!/bin/sh

. /etc/archbox.conf

startx
$PRIV $PREFIX/share/archbox/bin/uth killxdg
