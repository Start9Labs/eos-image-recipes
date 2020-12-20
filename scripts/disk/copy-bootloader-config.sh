#!/bin/sh
set -e

ls -lha $RECIPEDIR
ls -lha $ARTIFACTDIR/disk-ws-tmp/contents/isolinux/

install -v $RECIPEDIR/bootloaders/isolinux/* $ARTIFACTDIR/disk-ws-tmp/contents/isolinux/
install -v $RECIPEDIR/bootloaders/grub/grub.cfg $ARTIFACTDIR/disk-ws-tmp/contents/boot/grub/

touch $ARTIFACTDIR/disk-ws-tmp/contents/pureos
