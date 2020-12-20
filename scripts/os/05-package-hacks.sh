#!/bin/sh
set -e

# remove unwanted packages which are installed due to
# recommends/resolver issues
apt-get purge -y termit chromium
apt-get --purge -y autoremove
