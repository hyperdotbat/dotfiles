#!/bin/bash

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_FILES=("$CONFIG_DIR/waybar/config.jsonc" "$CONFIG_DIR/waybar/style.css")

trap "killall waybar" EXIT
#trap "killall -SIGUSR2 waybar" EXIT

while true; do
    waybar &
    inotifywait -e create,modify "${CONFIG_FILES[@]}"
    killall waybar
    #killall -SIGUSR2 waybar
done
