#!/bin/sh
set -e

MIRROR=$1
SUITE=$2

echo "# Main package repository for PureOS" > /etc/apt/sources.list
echo "deb $MIRROR $SUITE main\n" >> /etc/apt/sources.list

echo "# Important security updates" >> /etc/apt/sources.list
echo "deb $MIRROR $SUITE-security main\n" >> /etc/apt/sources.list

echo "# Other updates for resolving non-security issues" >> /etc/apt/sources.list
echo "deb $MIRROR $SUITE-updates main" >> /etc/apt/sources.list
