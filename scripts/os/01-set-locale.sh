#!/bin/sh
set -e

cat >/etc/default/locale<<EOF
LANG="C.UTF-8"
EOF
