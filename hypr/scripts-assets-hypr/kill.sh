#!/bin/bash
$activewindow_class="$(hyprctl activewindow -j | jq -r ".class")"
if [ $activewindow_class = "Steam" ]; then
    xdotool getactivewindow windowunmap
else
    hyprctl dispatch killactive ""
fi
