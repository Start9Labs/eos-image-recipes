#!/bin/sh
set -e

grub-mkstandalone \
	--format=x86_64-efi \
	--output=$ARTIFACTDIR/disk-ws-tmp/tmp/bootx64.efi \
	--locales="" \
	--fonts="" \
	boot/grub/grub.cfg=$RECIPEDIR/bootloaders/grub/grub-standalone.cfg

cd $ARTIFACTDIR/disk-ws-tmp/contents/EFI/boot
dd if=/dev/zero of=efiboot.img bs=1M count=20
mkfs.vfat efiboot.img
mmd -i efiboot.img efi EFI/boot
mcopy -vi efiboot.img $ARTIFACTDIR/disk-ws-tmp/tmp/bootx64.efi ::EFI/boot/
