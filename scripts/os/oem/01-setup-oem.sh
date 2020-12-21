#!/bin/bash
set -e

# hide non-OEM install options from menus
rm -f /usr/share/applications/calamares.desktop
rm -f /usr/share/applications/pureos-live-installer.desktop

# show OEM installer in GNOME Shell favourites
pureos_glib_schema_file="/usr/share/glib-2.0/schemas/20_pureos-gnome-settings.gschema.override"
if [[ -e "$pureos_glib_schema_file" ]]; then
    sed -i 's/pureos-live-installer.desktop/pureos-live-installer-oem.desktop/' $pureos_glib_schema_file
fi
