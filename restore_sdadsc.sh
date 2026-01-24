#!/bin/bash
# Restore udev rules if they were removed by a SteamOS update

# Path to your backup file in the home directory
BACKUP="/home/deck/.local/share/scawp/SDADSC/99-disable-steam-input.rules.bak"

if [ ! -f /etc/udev/rules.d/99-disable-steam-input.rules ]; then
    echo "SteamOS update detected. Restoring udev rules..."
    sudo cp "$BACKUP" /etc/udev/rules.d/99-disable-steam-input.rules
    sudo udevadm control --reload
fi
