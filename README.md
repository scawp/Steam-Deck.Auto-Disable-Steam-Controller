# Steam-Deck.Auto-Disable-Steam-Controller
Script to Automatically disable 

# WORK IN PROGRESS!
This will probably have bugs, so beware! log bugs under [issues](https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/issues)!

# About

When using External Controllers with the Steam Deck, sometimes the build in Steam Controller gets in the way by either not allowing the use of an External Controller at all, Having to Reassign Controller in the config each time you play a game, or interfering with Multiplayer games. This script simply listens to `udev` for when an External Controller is connected (either by Bluetooth or USB) then disables the Built in Steam Controller so that the (first) External Controller Defaults to Player One.

The Built in Steam Controller will be disabled until all External Controllers are disconnected.

# Currently Works With

Currently this script works with the following Bluetooth Controllers by default:
 - `Playstation 4 Controllers` (Identified as `Wireless Controller`) 
 - `Xbox One S/X Controllers` (Identified as `Xbox Wireless Controller`) 
 - `8BitDo SN30 gamepad`

The script also works with the following USB Controllers by default:
 - `Wired XBox 360 Controllers` (Identified as `Microsoft X-Box 360 pad`) 
 - `Wireless XBox 360 Controllers (Via Dongle)` (Identified as `Xbox 360 Wireless Receiver`) 

# Manually adding more Devices

To add more Bluetooth devices run `bluetoothctl devices` and add the name to `simple_device_list.txt` in `/home/deck/.local/share/scawp/ADSC/`

To add more USB devices run `lsusb` and add the name to `simple_device_list.txt`

Default `simple_device_list.txt`
```
Xbox Wireless Controller
Wireless Controller
8BitDo SN30 gamepad
Xbox 360 Wireless Receiver
Microsoft X-Box 360 pad
#ROCCAT ROCCAT Arvo
#MOSART Semi. 2.4G Wireless Mouse
```
Rows starting with `#` are ignored (for example my keyboard and mouse)

# Automatically adding more Devices
Not Yet Implemented!

# Installation

## Via Curl (One Line Install)

In Konsole type `curl -sSL https://raw.githubusercontent.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/main/curl_install.sh | bash`

a `sudo` password is required (run `passwd` if required first)

# How to Temporarily Disable

`touch /home/deck/.local/share/scawp/ADSC/conf/disable`

to re-enable `rm /home/deck/.local/share/scawp/ADSC/conf/disable`

# Uninstallation

To write

# "This is cool! How can I thank you?"
Why not drop me a sub over on my youtube channel ;) [Chinballs Gaming](https://www.youtube.com/chinballsTV?sub_confirmation=1)
