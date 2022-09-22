# Steam-Deck.Auto-Disable-Steam-Controller
Script to Automatically disable the built in Steam Controller when an External Controller (or Mouse or Keyboard) is connected and then enable once they are disconnected.

# WORK IN PROGRESS!
This will probably have bugs, so beware! log bugs under [issues](https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/issues)!

# About

When using External Controllers with the Steam Deck, sometimes the build in Steam Controller gets in the way by either not allowing the use of an External Controller at all, Having to Reassign Controller in the config each time you play a game, or interfering with Multiplayer games. This script simply listens to `udev` for when an External Controller is connected (either by Bluetooth or USB) then disables the Built in Steam Controller so that the (first) External Controller Defaults to Player One.

The Built in Steam Controller will be disabled until all External Controllers are disconnected.

# Currently Works With

Currently this script works with the following Bluetooth Controllers by default:
 - `Playstation 4 Controllers` (Identified as `Wireless Controller`) 
 - `Playstation 5 Controllers` (Identified as `Wireless Controller`) 
 - `Xbox One S/X Controllers` (Identified as `Xbox Wireless Controller`) 
 - `8BitDo SN30 gamepad`
 - And More! (see list below)

The script also works with the following USB Controllers by default:
 - `Wired XBox 360 Controllers` (Identified as `Microsoft X-Box 360 pad`) 
 - `Wireless XBox 360 Controllers (Via Dongle)` (Identified as `Xbox 360 Wireless Receiver`) 
 - And More! (see list below)

# Manually adding more Devices

To add more Bluetooth devices run `bluetoothctl devices` and add the name to `simple_device_list.txt` in `/home/deck/.local/share/scawp/SDADSC/`

To add more USB devices run `lsusb` and add the name to `simple_device_list.txt`

Default `simple_device_list.txt`
```

Xbox Wireless Controller
Brook XOne Adapter
Wireless Controller
8BitDo SN30 gamepad
8Bitdo SF30 gamepad
8Bitdo FC30 GamePad
8Bitdo FC30 II
8Bitdo NES30 GamePad
8Bitdo SFC30 GamePad
8Bitdo SNES30 GamePad
8Bitdo FC30 Pro
8Bitdo NES30 Pro
8Bitdo SF30 Pro
8Bitdo SN30 Pro
8Bitdo Joy
8Bitdo NES30 Arcade
8Bitdo Zero GamePad
8Bitdo N64 GamePad
Pro Controller
Nintendo RVL-CNT-01-UC
Xbox 360 Wireless Receiver
Microsoft X-Box 360 pad
Mad Catz,Inc. PS3 RF pad
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

`touch /home/deck/.local/share/scawp/SDADSC/conf/disable`

to re-enable `rm /home/deck/.local/share/scawp/SDADSC/conf/disable`

# Uninstallation

To write

# "This is cool! How can I thank you?"
### Why not drop me a sub over on my youtube channel ;) [Chinballs Gaming](https://www.youtube.com/chinballsTV?sub_confirmation=1)

### Also [Check out all these other things I'm making](https://github.com/scawp/Steam-Deck.Tools-List)
