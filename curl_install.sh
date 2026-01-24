#!/bin/bash
# Steam Deck Auto Disable Steam Controller by FGOD1983 (Update-Proof Mod)
set -e

# Repository URL
repo_url="https://raw.githubusercontent.com/FGOD1983/Steam-Deck.Auto-Disable-Steam-Controller/main"
tmp_dir="/tmp/scawp.SDADSC.install"
rules_install_dir="/etc/udev/rules.d"
script_install_dir="/home/deck/.local/share/scawp/SDADSC"
backup_file="$script_install_dir/99-disable-steam-input.rules.bak"
restore_script="$script_install_dir/restore_sdadsc.sh"

device_name="$(uname --nodename)"

if [ "$device_name" != "steamdeck" ] || [ "$(whoami)" != "deck" ]; then
  zenity --question --width=400 \
  --text="This code has been written specifically for the Steam Deck with user Deck \nIt appears you are running on a different system/non-standard configuration. \nAre you sure you want to continue?"
  if [ "$?" != 0 ]; then
    exit 1;
  fi
fi

zenity --question --width=400 \
  --text="Read $repo_url/README.md before proceeding. \nDo you want to proceed?"
if [ "$?" != 0 ]; then
  exit 0;
fi

echo "Creating directories..."
mkdir -p "$tmp_dir"
mkdir -p "$script_install_dir"

echo "Downloading required files from FGOD1983 repository..."
curl -sSL -o "$tmp_dir/disable_steam_input.sh" "$repo_url/disable_steam_input.sh"

echo "Copying script to $script_install_dir..."
sudo cp "$tmp_dir/disable_steam_input.sh" "$script_install_dir/disable_steam_input.sh"
sudo chmod 555 $script_install_dir/disable_steam_input.sh

# Remove old rules for a clean start
if [ -f "$rules_install_dir/99-disable-steam-input.rules" ]; then
  echo "Removing existing udev rules..."
  sudo rm "$rules_install_dir/99-disable-steam-input.rules"
fi

result=$(zenity --list \
  --title="What functionality do you desire?" \
  --checklist --column="Select" --width=840 --height=380 \
  --column="Device Type" --column="Description" \
    TRUE "Controller" "Disable Deck controls when connecting any USB or Bluetooth Controller" \
    FALSE "Keyboard" "Disable Deck controls when connecting any USB or Bluetooth Keyboard" \
    FALSE "Mouse" "Disable Deck controls when connecting any USB or Bluetooth Mouse")

# Write rules based on user selection
if [[ "$result" =~ "Controller" ]]; then
  echo "Adding Controller rules..."
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_JOYSTICK}=="1", ACTION=="add", RUN+="'$script_install_dir'/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules" > /dev/null
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_JOYSTICK}=="1", ACTION=="remove", RUN+="'$script_install_dir'/disable_steam_input.sh enable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules" > /dev/null
fi
if [[ "$result" =~ "Keyboard" ]]; then
  echo "Adding Keyboard rules..."
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_KEYBOARD}=="1", ACTION=="add", RUN+="'$script_install_dir'/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules" > /dev/null
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_KEYBOARD}=="1", ACTION=="remove", RUN+="'$script_install_dir'/disable_steam_input.sh enable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules" > /dev/null
fi
if [[ "$result" =~ "Mouse" ]]; then
  echo "Adding Mouse rules..."
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_MOUSE}=="1", ACTION=="add", RUN+="'$script_install_dir'/disable_steam_input.sh disable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules" > /dev/null
  echo 'KERNEL=="input*", SUBSYSTEM=="input", ENV{ID_INPUT_MOUSE}=="1", ACTION=="remove", RUN+="'$script_install_dir'/disable_steam_input.sh enable %k %E{NAME} %E{UNIQ} %E{PRODUCT}"' | sudo tee -a "$rules_install_dir/99-disable-steam-input.rules" > /dev/null
fi

# --- UPDATE PROOF LOGIC ---
echo "Creating backup of rules in $script_install_dir..."
sudo cp "$rules_install_dir/99-disable-steam-input.rules" "$backup_file"
sudo chmod 644 "$backup_file"

echo "Creating restore script..."
cat <<EOF > "$restore_script"
#!/bin/bash
# Restore udev rules if they were removed by a SteamOS update
if [ ! -f /etc/udev/rules.d/99-disable-steam-input.rules ]; then
    echo "SteamOS update detected. Restoring udev rules..."
    sudo cp "$backup_file" /etc/udev/rules.d/99-disable-steam-input.rules
    sudo udevadm control --reload
fi
EOF
chmod +x "$restore_script"

echo "Reloading udev services..."
sudo udevadm control --reload

echo "Done! Backup and restore script created in $script_install_dir"
echo "Please add $restore_script to your Autostart in Desktop Mode to remain update-proof."
