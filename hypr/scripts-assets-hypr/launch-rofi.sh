#!/bin/bash
mode=${1:-"drun"}
if pgrep -x rofi; then
    killall rofi
else
    r_override=""
    # change width based on aspect ratio
    x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
    y_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
    transform=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .transform')
    if [[ "$transform" == "1" || "$transform" == "3" ]]; then
        tmp=$x_monres
        x_monres=$y_monres
        y_monres=$tmp
    fi
    aspect_r=$((x_monres * 10 / y_monres))
    if (( aspect_r < 10 )); then
        R_WIDTH=64
        r_override+="#window { width: ${R_WIDTH}%; }"
    fi

    rofi -show "$mode" -modes combi,window,drun,run,ssh -combi-modes "window,drun,run,ssh" -theme-str "$r_override"
fi
