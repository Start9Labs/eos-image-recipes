#!/bin/sh

if [ -z "$1" ] || ! [ -f "$1" ]; then
    >&2 echo "usage: $0 <ISO_PATH>"
    exit 1
fi

MOUNTPOINT=$(mktemp -d)
sudo mount "$1" $MOUNTPOINT
cp $MOUNTPOINT/casper/filesystem.squashfs $(dirname $1)/eos.x86_64.squashfs
sudo umount $MOUNTPOINT
rm -r $MOUNTPOINT