#!/bin/bash
cd "$(dirname "$0")" || exit 1
WAYBAR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
WAYBAR_override_darkmode_file="$WAYBAR_CONFIG_DIR/.dark-mode-import_cache.css"
WAYBAR_DARKMODE_ENABLED=false
if [ -f "$WAYBAR_override_darkmode_file" ] && grep -q '[^[:space:]]' "$WAYBAR_override_darkmode_file"; then
    WAYBAR_DARKMODE_ENABLED=true
fi

if [ -n "$1" ]; then
    if [ "$1" = "true" ] || [ "$1" = "1" ]; then
        WAYBAR_DARKMODE_ENABLED=false
    elif [ "$1" = "false" ] || [ "$1" = "0" ]; then
        WAYBAR_DARKMODE_ENABLED=true
    fi
fi


if [ "$WAYBAR_DARKMODE_ENABLED" = false ]; then
    echo '@import url("style-darkmode.css");' > $WAYBAR_override_darkmode_file
else
    echo '' > $WAYBAR_override_darkmode_file
fi