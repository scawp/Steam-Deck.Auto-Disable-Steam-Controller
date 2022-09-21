#!/bin/bash
#Steam Deck Auto Disable Steam Controller by scawp
#License: DBAD: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/blob/main/LICENSE.md
#Source: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller
# Use at own Risk!

#curl -sSL https://raw.githubusercontent.com/scawp/Auto-Disable-Steam-Controller/curl_install.sh | bash

#stop running script if anything returns an error (non-zero exit )
set -e

repo_url="https://raw.githubusercontent.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/main"

tmp_dir="/tmp/scawp/ADSC"

rules_install_dir="/etc/udev/rules.d"
script_install_dir="/home/deck/.local/share/scawp/ADSC"

device_name="$(uname --nodename)"
user="$(id -u deck)"

if [ "$device_name" != "steamdeck" ] || [ "$user" != "1000" ]; then
  zenity --question --width=400 \
  --text="This code has been written specifically for the Steam Deck with user Deck \
  \nIt appears you are running on a different system/non-standard configuration. \
  \nAre you sure you want to continue?"
  if [ "$?" != 0 ]; then
    #NOTE: This code will never be reached due to "set -e", the system will already exit for us but just incase keep this
    echo "bye then! xxx"
    exit 1;
  fi
fi

zenity --question --width=400 \
  --text="Read $repo_url/README.md before proceeding. \
\nDo you want to proceed?"
if [ "$?" != 0 ]; then
  #NOTE: This code will never be reached due to "set -e", the system will already exit for us but just incase keep this
  echo "bye then! xxx"
  exit 0;
fi
echo "Making tmp folder $tmp_dir"
mkdir -p "$tmp_dir"

echo "Downloading Required Files"
curl -o "$tmp_dir/disable_steam_input.sh" "$repo_url/disable_steam_input.sh"
curl -o "$tmp_dir/simple_device_list.txt" "$repo_url/conf/simple_device_list.txt"
curl -o "$tmp_dir/99-disable-steam-input.rules" "$repo_lib_dir/99-disable-steam-input.rules"

echo "Making script folder $script_install_dir"
mkdir -p "$script_install_dir/conf"

echo "Copying $tmp_dir/simple_device_list.txt to $script_install_dir/conf/simple_device_list.txt"
sudo cp "$tmp_dir/simple_device_list.txt" "$script_install_dir/conf/simple_device_list.txt"

echo "Copying $tmp_dir/disable_steam_input.sh to $script_install_dir/disable_steam_input.sh"
sudo cp "$tmp_dir/disable_steam_input.sh" "$script_install_dir/disable_steam_input.sh"

echo "Adding Execute and Removing Write Permissions"
sudo chmod 555 $script_install_dir/disable_steam_input.sh

echo "Copying $tmp_dir/99-disable-steam-input.rules to $rules_install_dir/99-disable-steam-input.rules"
sudo cp "$tmp_dir/99-disable-steam-input.rules" "$rules_install_dir/99-disable-steam-input.rules"

echo "Reloading Services"
sudo udevadm control --reload

echo "Done."
