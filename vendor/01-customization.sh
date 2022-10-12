#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

wget https://github.com/Start9Labs/embassy-os-deb/releases/download/0.3.2-testing/embassyos_0.3.2-1_amd64.deb
dpkg -i embassyos_0.3.2-1_amd64.deb || true
rm embassyos_0.3.2-1_amd64.deb

apt-get update
apt-get purge firewalld
apt-get install -yf yq