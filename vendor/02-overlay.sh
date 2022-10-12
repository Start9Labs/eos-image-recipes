#!/bin/sh
# Part of raspi-config https://github.com/RPi-Distro/raspi-config
#
# See LICENSE file for copyright and license details

set -e

cat > /usr/sbin/grub-probe-overlay << 'EOF'
#!/bin/sh

ARGS=

for ARG in $@; do
 if [ "${ARG%%[!/]*}" = "/" ]; then

  OPTIONS=

  path="$ARG"
  while true; do
   if FSTYPE=$( findmnt -n -o FSTYPE "$path" ); then
    if [ "$FSTYPE" = "overlay" ]; then
  OPTIONS=$(findmnt -n -o OPTIONS "$path")
  break
 else
  break
    fi
   fi
   if [ "$path" = "/" ]; then break; fi
   path=$(dirname "$path")
  done

  if LOWERDIR=$(echo "$OPTIONS" | grep -m 1 -oP 'lowerdir=\K[^,]+'); then
   #echo "[DEBUG] Overlay filesystem detected ${ARG} --> ${LOWERDIR}${ARG%*/}" 1>&2
   ARG=/overlay"${LOWERDIR}${ARG%*/}"
  fi
 fi
 ARGS="$ARGS $ARG"
done

grub-probe-default $ARGS

exit $?
EOF
chmod +x /usr/sbin/grub-probe-overlay
mv /usr/sbin/grub-probe /usr/sbin/grub-probe-default
ln -s /usr/sbin/grub-probe-overlay /usr/sbin/grub-probe

cat > /etc/initramfs-tools/scripts/overlay << 'EOF'
# Local filesystem mounting			-*- shell-script -*-

#
# This script overrides local_mount_root() in /scripts/local
# and mounts root as a read-only filesystem with a temporary (rw)
# overlay filesystem.
#

. /scripts/local

local_mount_root()
{
	local_top
	local_device_setup "${ROOT}" "root file system"
	ROOT="${DEV}"

	# Get the root filesystem type if not set
	if [ -z "${ROOTFSTYPE}" ]; then
		FSTYPE=$(get_fstype "${ROOT}")
	else
		FSTYPE=${ROOTFSTYPE}
	fi

	local_premount

	# CHANGES TO THE ORIGINAL FUNCTION BEGIN HERE
	# N.B. this code still lacks error checking

	modprobe ${FSTYPE}
	checkfs ${ROOT} root "${FSTYPE}"

	# Create directories for root and the overlay
	mkdir /lower /upper

	# Mount read-only root to /lower
	if [ "${FSTYPE}" != "unknown" ]; then
		mount -r -t ${FSTYPE} ${ROOTFLAGS} ${ROOT} /lower
	else
		mount -r ${ROOTFLAGS} ${ROOT} /lower
	fi

	modprobe overlay || insmod "/lower/lib/modules/$(uname -r)/kernel/fs/overlayfs/overlay.ko"

	# Mount a tmpfs for the overlay in /upper
	mount -t tmpfs tmpfs /upper
	mkdir /upper/data /upper/work

	# Mount the final overlay-root in $rootmnt
	mount -t overlay \
	    -olowerdir=/lower,upperdir=/upper/data,workdir=/upper/work \
	    overlay ${rootmnt}

	mkdir -p ${rootmnt}/overlay/lower
	mount --bind /lower ${rootmnt}/overlay/lower
}
EOF

  # add the overlay to the list of modules
if ! grep overlay /etc/initramfs-tools/modules > /dev/null; then
  echo overlay >> /etc/initramfs-tools/modules
fi

for KERN in $(ls /boot/vmlinuz-* | sed 's/\/boot\/vmlinuz-//g'); do
	mv /boot/initrd.img-"$KERN" /boot/initrd.img-"$KERN"-old

	# build the new initramfs
	update-initramfs -c -k "$KERN"

	# rename it so we know it has overlay added
	mv /boot/initrd.img-"$KERN" /boot/initrd.img-"$KERN"-overlay
	mv /boot/initrd.img-"$KERN"-old /boot/initrd.img-"$KERN"
done

if grep -q "overlay" /etc/initramfs-tools/modules ; then
	sed -i /etc/initramfs-tools/modules -e '/overlay/d'
fi