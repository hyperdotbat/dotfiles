#/bin/bash

POWER_BUTTON_ACTION="suspend" # "suspend", "power-off" or "wlogout"

## move the swww restore into checking if its the current tool etcc
if [ "$POWER_BUTTON_ACTION" == "suspend" ]; then
    LOCK_SCREEN_ON_POWER_BUTTON_SUSPEND=true
    if [ "$LOCK_SCREEN_ON_POWER_BUTTON_SUSPEND" = true ]; then
        hyprlock & sleep 0.5 && systemctl suspend && swww restore
    else
        systemctl suspend && swww restore
    fi
elif [ "$POWER_BUTTON_ACTION" == "wlogout" ]; then
    wlogout
else
    systemctl poweroff
fi
