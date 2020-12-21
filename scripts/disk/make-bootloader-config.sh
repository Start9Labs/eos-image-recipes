#!/bin/sh
set -e

IMAGE_FLAVOR=$1
VERSION=$2

DISK_CONTENTS_DIR=$ARTIFACTDIR/disk-ws-tmp/contents
WS_TMP_DIR=$ARTIFACTDIR/disk-ws-tmp/tmp

sed -e s/@VERSION@/"$VERSION"/g $RECIPEDIR/bootloaders/splash.svg.in > $WS_TMP_DIR/splash.svg
rsvg-convert --format png --height 480 --width 640 "$WS_TMP_DIR/splash.svg" -o "$WS_TMP_DIR/splash.png"


install -v $WS_TMP_DIR/splash.png $DISK_CONTENTS_DIR/isolinux/
install -v $RECIPEDIR/bootloaders/isolinux/* $DISK_CONTENTS_DIR/isolinux/

case "$IMAGE_FLAVOR" in
  live)
  ;;
  oem)
    install -v $RECIPEDIR/bootloaders/isolinux-oem/* $DISK_CONTENTS_DIR/isolinux/
  ;;
  *)
    echo "ERROR: Image flavor '$IMAGE_FLAVOR' is unknown" >&2
    exit 1
  ;;
esac

install -v $RECIPEDIR/bootloaders/grub/grub.cfg $DISK_CONTENTS_DIR/boot/grub/
touch $DISK_CONTENTS_DIR/pureos
