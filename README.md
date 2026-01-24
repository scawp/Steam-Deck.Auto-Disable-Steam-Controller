# Steam-Deck.Auto-Disable-Steam-Controller
Script to Automatically disable the built in Steam Controller when an External Controller (or Mouse or Keyboard) is connected and then enable once they are disconnected.

# All thanks goes out to the original creator of this [script](https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller) 

# WORK IN PROGRESS!
This will probably have bugs, so beware! log bugs under [issues](https://github.com/FGOD1983/Steam-Deck.Auto-Disable-Steam-Controller/issues)!

:exclamation: This has only been tested on one Deck (eg mine)!

The Deck registers:
- Virtual Keyboard with `Product_ID` of `11/1/1/ab83`
- A `JOYSTICK` with `Product_ID` of `3/28de/1205/*`

These will be ignored by this script.

# Video Guide
https://youtu.be/0sACNVwWXw4

# About
When using External Controllers with the Steam Deck, sometimes the build in Steam Controller gets in the way by either not allowing the use of an External Controller at all, Having to Reassign Controller in the config each time you play a game, or interfering with Multiplayer games. This script simply listens to `udev` for when an External Controller is connected (either by Bluetooth or USB) then disables the Built in Steam Controller so that the (first) External Controller Defaults to Player One.

The Built in Steam Controller will be disabled until all External Controllers are disconnected.

# Update (Update-Proof Edition)
This version has been modified to be **SteamOS Update-Proof**. Because SteamOS overwrites the `/etc` directory during system updates, this script now creates a backup of your rules in the `/home` directory and includes a restoration script.

# Currently Works With
This script has been tested to work with the following Bluetooth Controllers:
 - `Playstation 4 Controllers` (Identified as `Wireless Controller`) 
 - `Playstation 5 Controllers` (Identified as `Wireless Controller`) 
 - `Xbox One/Series S/X Controllers` (Identified as `Xbox Wireless Controller`) 
 - `Wiimote`
 - `WiiU Pro Controller`
 - `8BitDo SN30 gamepad`
 - And More!

The script also works with the following USB Controllers:
 - `Wired XBox 360 Controllers` (Identified as `Microsoft X-Box 360 pad`) 
 - `Wireless XBox 360 Controllers (Via Dongle)` (Identified as `Xbox 360 Wireless Receiver`) 
 - And More!

The script can also be configured to work with External Mouse & Keyboards both USB & Bluetooth; select your preferences during installation.

# Installation

## Via Curl (One Line Install)
In Konsole type:
`curl -sSL https://raw.githubusercontent.com/FGOD1983/Steam-Deck.Auto-Disable-Steam-Controller/main/curl_install.sh | bash`

*A `sudo` password is required (run `passwd` first if you haven't set one).*

## Making it Update-Proof
To ensure the script keeps working after a SteamOS update:
1. Go to **System Settings** -> **Startup and Shutdown** -> **Autostart**.
2. Click **+ Add Script...**
3. Select the restore script located at: `/home/deck/.local/share/scawp/SDADSC/restore_sdadsc.sh`

# Uninstallation
Run the following commands:

`sudo rm -r /home/deck/.local/share/scawp/SDADSC` # To delete the code and backups

`sudo rm /etc/udev/rules.d/99-disable-steam-input.rules` # To delete the system rule

`sudo udevadm control --reload` # To reload the service

*You may need to reboot if you ran these lines while a controller was connected.*

# Troubleshooting
Some basic logs are stored in `/tmp/scawp/SDADSC/debug.log`. These are deleted on reboot but may come in handy when raising an issue.
