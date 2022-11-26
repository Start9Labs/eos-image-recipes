#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt install -y /root/embassyos_0.3.x-1_amd64.deb
rm /root/embassyos_0.3.x-1_amd64.deb

useradd --shell /bin/bash -m start9
echo start9:embassy | chpasswd
usermod -aG sudo start9

sed -i '/ USERNAME=/d' /etc/casper.conf
sed -i 's/HOST="pureos"/HOST="embassy"/g' /etc/casper.conf
sed -i 's/BUILD_SYSTEM="PureOS"/BUILD_SYSTEM="embassyOS"/g' /etc/casper.conf

echo "start9 ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/010_start9-nopasswd"

/usr/lib/embassy/scripts/enable-kiosk