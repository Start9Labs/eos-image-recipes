#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update

wget https://downloads.nestybox.com/sysbox/releases/v0.5.2/sysbox-ce_0.5.2-0.linux_amd64.deb
sha256sum sysbox-ce_0.5.2-0.linux_amd64.deb | grep f13fc0e156f72c6f8bd48e206c59482f83f19acc229701c74e0f23baafa724d8
apt install -y sysbox-ce_0.5.2-0.linux_amd64.deb
rm sysbox-ce_0.5.2-0.linux_amd64.deb

apt install -y /root/embassyos_0.3.x-1_amd64.deb
rm /root/embassyos_0.3.x-1_amd64.deb

useradd --shell /bin/bash -m start9
echo start9:embassy | chpasswd
usermod -aG sudo start9

if ! [[ "$(cat /usr/lib/embassy/ENVIRONMENT.txt)" =~ (^|-)dev($|-) ]]; then
    passwd -l start9
fi

sed -i '/ USERNAME=/d' /etc/casper.conf
sed -i 's/HOST="pureos"/HOST="embassy"/g' /etc/casper.conf
sed -i 's/BUILD_SYSTEM="PureOS"/BUILD_SYSTEM="embassyOS"/g' /etc/casper.conf

echo "start9 ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/010_start9-nopasswd"

/usr/lib/embassy/scripts/enable-kiosk