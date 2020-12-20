#!/bin/sh
set -e

# update APT metadata / DEP-11 YAML
apt-get update

if [ -e /usr/bin/appstreamcli ]
then
	/usr/bin/appstreamcli refresh --force --verbose
fi
