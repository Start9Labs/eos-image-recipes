#!/bin/sh

cd /tmp
wget http://ftp.debian.org/debian/pool/main/l/linux/linux-image-6.0.0-0.deb11.2-amd64-dbg_6.0.3-1~bpo11+1_amd64.deb
apt install ./linux-image-6.0.0-0.deb11.2-amd64-dbg_6.0.3-1~bpo11+1_amd64.deb 