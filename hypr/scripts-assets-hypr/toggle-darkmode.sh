#!/bin/bash
cd "$(dirname "$0")" || exit 1

DARKMODE_ENABLE=false
isdarkmode_file=".is-darkmode_cache"
if [ -f "$isdarkmode_file" ] && grep -q '[^[:space:]]' "$isdarkmode_file"; then
    DARKMODE_ENABLE=true
fi

if [ -n "$1" ]; then
    if [ "$1" = "true" ] || [ "$1" = "1" ]; then
        DARKMODE_ENABLE=true
    elif [ "$1" = "false" ] || [ "$1" = "0" ]; then
        DARKMODE_ENABLE=false
    fi
fi

if [ "$DARKMODE_ENABLE" = false ]; then
    echo 'true' > $isdarkmode_file
else
    echo '' > $isdarkmode_file
fi

HYPRLAND_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
HYPRLAND_override_darkmode_file="$HYPRLAND_CONFIG_DIR/.import-darkmode_cache.conf"

if [ "$DARKMODE_ENABLE" = true ]; then
    echo 'source = .overrides_darkmode.conf' > $HYPRLAND_override_darkmode_file
else
    echo '' > $HYPRLAND_override_darkmode_file
fi

WAYBAR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
WAYBAR_override_darkmode_file="$WAYBAR_CONFIG_DIR/.import-darkmode_cache.css"

if [ "$DARKMODE_ENABLE" = true ]; then
    echo '@import url("style-darkmode.css");' > $WAYBAR_override_darkmode_file
else
    echo '' > $WAYBAR_override_darkmode_file
fi

WLOGOUT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wlogout"
WLOGOUT_override_darkmode_file="$WLOGOUT_CONFIG_DIR/.import-darkmode_cache.css"

if [ "$DARKMODE_ENABLE" = true ]; then
    echo '@import url("style-darkmode.css");' > $WLOGOUT_override_darkmode_file
else
    echo '' > $WLOGOUT_override_darkmode_file
fi

ROFI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
ROFI_override_darkmode_file="$ROFI_CONFIG_DIR/.import-darkmode_cache.rasi"

if [ "$DARKMODE_ENABLE" = true ]; then
    echo '@theme "style-dark"' > $ROFI_override_darkmode_file
else
    echo '' > $ROFI_override_darkmode_file
fi