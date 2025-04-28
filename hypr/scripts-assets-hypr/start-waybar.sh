#!/bin/bash

CONFIG_DIR_OG="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"

# Resolve symlink
CONFIG_DIR=$CONFIG_DIR_OG
if [ -L "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(readlink -f "$CONFIG_DIR_OG")"
fi
echo "$CONFIG_DIR"

trap "killall waybar" EXIT

while true; do
    waybar &
    inotifywait -e create,modify -r "$CONFIG_DIR"
    killall waybar
done
