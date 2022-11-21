#!/bin/sh
set -e

cp $ROOTDIR/boot/vmlinuz-6.0.0-4-amd64 \
    $ARTIFACTDIR/disk-ws-tmp/contents/casper/vmlinuz
cp $ROOTDIR/boot/initrd.img-6.0.0-4-amd64 \
    $ARTIFACTDIR/disk-ws-tmp/contents/casper/initrd.img
