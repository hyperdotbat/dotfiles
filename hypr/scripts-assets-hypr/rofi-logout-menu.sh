#!/bin/bash
 
r_override="""
* {
    font: 'JetBrainsMono Nerd Font 12';
}
#window { width: 20%; height: 30%; }
"""

options=" Lock\n󰍃 Logout\n Reboot\n Shutdown\n⏾ Suspend"
chosen=$(echo -e "$options" | rofi -dmenu -theme-str "$r_override" -markup-rows -i -p "" -me-select-entry '' -me-accept-entry 'MousePrimary')
 
case "$chosen" in
    " Lock") hyprlock ;;
    "󰍃 Logout") hyprctl dispatch exit ;;
    " Reboot") systemctl reboot ;;
    " Shutdown") systemctl poweroff ;;
    "⏾ Suspend") systemctl suspend ;;
esac