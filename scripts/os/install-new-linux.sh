#!/bin/sh

cd /tmp
wget http://ftp.us.debian.org/debian/pool/main/l/linux-signed-amd64/linux-image-6.0.0-4-amd64_6.0.8-1_amd64.deb
apt install ./linux-image-6.0.0-4-amd64_6.0.8-1_amd64.deb 