#!/bin/bash
#Steam Deck Auto Disable Steam Controller by scawp
#License: DBAD: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/blob/main/LICENSE.md
#Source: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller
# Use at own Risk!

set -e

#script_install_dir="/home/deck/.local/share/scawp/SDADSC"
tmp_dir="/tmp/scawp/SDADSC"

mkdir -p "$tmp_dir"

#log debug info, deletes on reboot
echo -e "\n$1 - $2 - $3 - $4 - $5" >> "$tmp_dir/debug.log"

#TODO should be $5, bad escaping in rules
if [ "$4" = "3/28de/11ff/1" ];then
  #Steam converts all inputs to virtual 360 pads with this id (I hope!), exit and  ignore.
    echo "VIRTUAL 360 Pad!!!" >> "$tmp_dir/debug.log"
exit 0;
fi

#TODO check if all Steam Decks identify as Product 3/28de/1205/111
if [ "$5" = "3/28de/1205/111" ];then
  #Steam Deck Built-in Controllers, exit and ignore
  echo "STEAM DECK!!!" >> "$tmp_dir/debug.log"
exit 0;
fi

#TODO check if all Steam Deck Virtual Keyboards identify as Product 11/1/1/ab83
if [ "$4" = "11/1/1/ab83" ];then
  #Steam registers a Virtual Keyboard \"AT Translated Set 2 keyboard\", exit and ignore.
  echo "STEAM DECK VIRTUAL KEYBOARD!!!" >> "$tmp_dir/debug.log"
exit 0;
fi

if [ "$1" = "disable" ];then
  if [ ! -f "$tmp_dir/controller_id.txt" ];then
    echo "3-3:1.0" > /sys/bus/usb/drivers/usbhid/unbind
    echo "3-3:1.1" > /sys/bus/usb/drivers/usbhid/unbind
    echo "3-3:1.2" > /sys/bus/usb/drivers/usbhid/unbind
  fi
  echo "$2" >> "$tmp_dir/controller_id.txt"

elif [ "$1" = "enable" ] && [ -f "$tmp_dir/controller_id.txt" ] && [ -n "$(grep -i "^$2$" "$tmp_dir/controller_id.txt")" ];then
  sed -i "/^$2$/d" "$tmp_dir/controller_id.txt"

  if [ ! -s "$tmp_dir/controller_id.txt" ];then
    echo "Re-enabling Deck Controls!!!" >> "$tmp_dir/debug.log"
    rm "$tmp_dir/controller_id.txt"
    echo "3-3:1.0" > /sys/bus/usb/drivers/usbhid/bind
    echo "3-3:1.1" > /sys/bus/usb/drivers/usbhid/bind
    echo "3-3:1.2" > /sys/bus/usb/drivers/usbhid/bind
  fi
fi

exit 0;
