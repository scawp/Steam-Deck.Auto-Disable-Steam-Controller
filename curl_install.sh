#!/bin/bash
#Steam Deck Auto Disable Steam Controller by scawp
#License: DBAD: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/blob/main/LICENSE.md
#Source: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller
# Use at own Risk!

#curl -sSL https://raw.githubusercontent.com/scawp/Auto-Disable-Steam-Controller/curl_install.sh | bash

#stop running script if anything returns an error (non-zero exit )
set -e

repo_url="https://raw.githubusercontent.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/main"

tmp_dir="/tmp/scawp.SDADSC.install"

rules_install_dir="/etc/udev/rules.d"
script_install_dir="/home/deck/.local/share/scawp/SDADSC"

# for debugging installer
#rules_install_dir="$tmp_dir/script"
#script_install_dir="$tmp_dir/script"

device_name="$(uname --nodename)"

if [ "$device_name" != "steamdeck" ] || [ "$(whoami)" != "deck" ]; then
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

echo "Making script folder $script_install_dir"
mkdir -p "$script_install_dir"

echo "Copying $tmp_dir/disable_steam_input.sh to $script_install_dir/disable_steam_input.sh"
sudo cp "$tmp_dir/disable_steam_input.sh" "$script_install_dir/disable_steam_input.sh"

echo "Adding Execute and Removing Write Permissions"
sudo chmod 555 $script_install_dir/disable_steam_input.sh

#remove old installed files if found
if [ -f "$script_install_dir/conf" ]; then
  echo "deleting old install files"
  sudo rm "$script_install_dir/conf/simple_device_list.txt"
  sudo rm -d "$script_install_dir/conf"
fi
if [ -f "$rules_install_dir/99-disable-steam-input.rules" ]; then
  echo "Removing old rule"
  sudo rm "$rules_install_dir/99-disable-steam-input.rules"
fi

result=$(zenity --list \
  --title="What functionallity do you desire? Select any or all" \
  --checklist --column="Select" --width=840 --height=380 \
  --column="Device Type" --column="Description" \
    TRUE "Controller" "Disable Deck controls when connecting any USB or Bluetooth Controller" \
    FALSE "Keyboard" "Disable Deck controls when connecting any USB or Bluetooth Keyboard" \
    FALSE "Mouse" "Disable Deck controls when connecting any USB or Bluetooth Mouse")

if [[ "$result" == "" ]]; then
  echo "None selected"
fi

if [[ "$result" =~ "Controller" ]]; then
  echo "Add Controller Rules"

  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_JOYSTICK}=="1", ACTION=="add", RUN+="/home/deck/.local/share/scawp/SDADSC/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules"

  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_JOYSTICK}=="1", ACTION=="remove", RUN+="/home/deck/.local/share/scawp/SDADSC/disable_steam_input.sh enable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules"

fi
if [[ "$result" =~ "Keyboard" ]]; then
  echo "Add Keyboard Rules"
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_KEYBOARD}=="1", ACTION=="add", RUN+="/home/deck/.local/share/scawp/SDADSC/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules"
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_KEYBOARD}=="1", ACTION=="remove", RUN+="/home/deck/.local/share/scawp/SDADSC/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules"
fi
if [[ "$result" =~ "Mouse" ]]; then
  echo "Add Mouse Rules"
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_MOUSE}=="1", ACTION=="add", RUN+="/home/deck/.local/share/scawp/SDADSC/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules"
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_MOUSE}=="1", ACTION=="remove", RUN+="/home/deck/.local/share/scawp/SDADSC/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules"
fi

echo "Reloading Services"
sudo udevadm control --reload

echo "Done."
