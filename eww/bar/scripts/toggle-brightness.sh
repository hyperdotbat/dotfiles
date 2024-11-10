#!/bin/bash

current_brightness=$(brightnessctl get)

max_brightness=$(brightnessctl max)

current_percentage=$((current_brightness * 100 / max_brightness))

# Toggle between 0% and 100%
if [ "$current_percentage" -eq 100 ]; then
    brightnessctl set 0%
else
    brightnessctl set 100%
    dunstify "t2" -a "100" "Brightness" -r 91191 -t 800
fi
