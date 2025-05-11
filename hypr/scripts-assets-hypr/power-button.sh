#!/bin/bash
cd "$(dirname "$0")" || exit 1

POWER_BUTTON_ACTION="suspend" # "suspend", "power-off" or "wlogout"

if [ "$POWER_BUTTON_ACTION" == "suspend" ]; then
    ./suspend.sh
elif [ "$POWER_BUTTON_ACTION" == "wlogout" ]; then
    wlogout
else
    systemctl poweroff
fi
