# Steam-Deck.Auto-Disable-Steam-Controller
Script to Automatically disable the built in Steam Controller when an External Controller (or Mouse or Keyboard) is connected and then enable once they are disconnected.

# "This is cool! How can I thank you?"
### Why not drop me a sub over on my youtube channel ;) [Chinballs Gaming](https://www.youtube.com/chinballsTV?sub_confirmation=1)

### Also [Check out all these other things I'm making](https://github.com/scawp/Steam-Deck.Tools-List)

# WORK IN PROGRESS!
This will probably have bugs, so beware! log bugs under [issues](https://github.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/issues)!

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

# Update

This has been massively simplified over previous versions and should now would with any Controller (as long as it identifies itself as a "Joystick") and can also work with External Mouse & Keyboards.

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

The script can also been configure to work with External Mouse & Keyboards both USB & Bluetooth, select your preferences on install

# Installation

## Via Curl (One Line Install)

In Konsole type `curl -sSL https://raw.githubusercontent.com/scawp/Steam-Deck.Auto-Disable-Steam-Controller/main/curl_install.sh | bash`

a `sudo` password is required (run `passwd` if required first)

# Uninstallation

Run the following codes:

`sudo rm -r /home/deck/.local/share/scawp/SDADSC` #To delete the code

`sudo rm -r /etc/udev/rules.d/99-disable-steam-input.rules` #To delete the rule

`sudo udevadm control --reload` #To reload the service


You may need to reboot if you ran these lines when a bluetooth controller was connected.

# Troubleshooting

Some basic logs are stored `/tmp/scawp/SDADSC/debug.log`, these are deleted on rebooting, may come in handy when raising an issue ;)

