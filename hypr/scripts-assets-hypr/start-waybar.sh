#!/bin/bash

CONFIG_DIR_OG="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"

# Resolve symlink
CONFIG_DIR=$CONFIG_DIR_OG
if [ -L "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(readlink -f "$CONFIG_DIR_OG")"
fi
echo "$CONFIG_DIR"

# trap "killall -SIGUSR2 waybar" EXIT
trap "killall waybar" EXIT

# waybar &
while true; do
    # Make any files that dont exist but should
    [ -f "$CONFIG_DIR/.import-darkmode_cache.css" ] || touch "$CONFIG_DIR/.import-darkmode_cache.css"
    [ -f "$CONFIG_DIR/.overrides.css" ] || touch "$CONFIG_DIR/.overrides.css"

    waybar &
    inotifywait -e create,modify -r "$CONFIG_DIR"
    # killall -SIGUSR2 waybar
    killall waybar
done
