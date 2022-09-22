#!/bin/bash
#Steam Deck Auto Disable Steam Controller by scawp
#License: DBAD: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/blob/main/LICENSE.md
#Source: https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller
# Use at own Risk!

set -e

#TODO should be $5, bad escaping in rules
if [ "$4" = "3/28de/11ff/1" ];then
  #Steam converts all inputs to virtual 360 pads with this id (I hope!), ignore.
  exit 0;
fi

script_install_dir="/home/deck/.local/share/scawp/ADSC"
conf_dir="$script_install_dir/conf"
tmp_dir="/tmp/scawp/ADSC"

mkdir -p "$tmp_dir"
mkdir -p "$conf_dir"

mode="simple" #TODO: Advanced

#debug=1 #uncomment to use local repository
if [ "$debug" = "1" ];then
  script_install_dir="$(dirname $(realpath "$0"))"
  tmp_dir="$script_install_dir/tmp/scawp/"
  conf_dir="$script_install_dir/conf"
  mkdir -p "$tmp_dir"
  mkdir -p "$conf_dir"
  echo "===================================================" >> $script_install_dir/debug.log
  echo "$mode - $1 - $2 - $3 - $4 - $5" >> $script_install_dir/debug.log
fi

action="$1"
input_event="$2" #%k
device_name="$3" #%E{NAME}
device_id="$4" #%E{UNIQ}" For Bluetooth #%E{PRODUCT} for usb

# if usb remove bus and version eg "3/28de/11ff/1" > 28de:11ff
if [ -n "$(echo "$device_id" | grep -o '/.*/')" ];then
  device_id="$(echo "$device_id" | grep -o '/.*/' | sed -e 's&^/&&' -e 's&/$&&' -e 's&/&:&')"
fi

#TODO: Make config script to allow disabling of script
if [ ! -f "$conf_dir/disabled" ];then
  if [ "$mode" = "simple" ] && [ -n "$(grep "^$device_name$" "$conf_dir/simple_device_list.txt")" ]; then
    if [ "$action" = "disable" ];then
      if [ ! -f "$tmp_dir/controller_id.txt" ];then
        echo "3-3:1.0" > /sys/bus/usb/drivers/usbhid/unbind
        echo "3-3:1.1" > /sys/bus/usb/drivers/usbhid/unbind
        echo "3-3:1.2" > /sys/bus/usb/drivers/usbhid/unbind
      fi
      echo "$device_id" >> "$tmp_dir/controller_id.txt"

    elif [ "$action" = "enable" ] && [ -f "$tmp_dir/controller_id.txt" ] && [ -n "$(grep -i "^$device_id$" "$tmp_dir/controller_id.txt")" ];then
      sed -i "/^$device_id$/d" "$tmp_dir/controller_id.txt"

      if [ ! -s "$tmp_dir/controller_id.txt" ];then
        rm "$tmp_dir/controller_id.txt"
        echo "3-3:1.0" > /sys/bus/usb/drivers/usbhid/bind
        echo "3-3:1.1" > /sys/bus/usb/drivers/usbhid/bind
        echo "3-3:1.2" > /sys/bus/usb/drivers/usbhid/bind
      fi
    fi
  fi
fi

exit 0;