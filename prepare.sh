#!/bin/sh
set -e
set -x

export DEBIAN_FRONTEND=noninteractive
apt-get install -yq \
	debos \
	squashfs-tools \
	librsvg2-bin \
	mtools \
	dosfstools \
	isolinux \
	grub-common \
	grub-efi-amd64-bin \
	grub-pc-bin \
	xorriso \
	zsync
