#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

curl -LO https://github.com/Start9Labs/embassy-os-deb/releases/download/0.3.2-testing/embassyos_0.3.2-1_amd64.deb
dpkg -i embassyos_0.3.2-1_amd64.deb || true
rm embassyos_0.3.2-1_amd64.deb

apt-get update
apt-get install -yf

useradd --shell /bin/bash -m start9
echo start9:embassy | chpasswd
usermod -aG sudo start9