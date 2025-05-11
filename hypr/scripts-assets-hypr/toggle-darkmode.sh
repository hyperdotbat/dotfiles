#!/bin/bash
cd "$(dirname "$0")" || exit 1

UPDATE_WALLPAPER_SLIDESHOW=true

DARKMODE_ENABLE=true
isdarkmode_file=".is-darkmode_cache"
if [ -f "$isdarkmode_file" ] && grep -q '[^[:space:]]' "$isdarkmode_file"; then
    DARKMODE_ENABLE=false
fi

if [ -n "$1" ]; then
    if [ "$1" = "true" ] || [ "$1" = "1" ]; then
        DARKMODE_ENABLE=true
    elif [ "$1" = "false" ] || [ "$1" = "0" ]; then
        DARKMODE_ENABLE=false
    fi
fi

if [ "$DARKMODE_ENABLE" = true ]; then
    echo 'true' > $isdarkmode_file
    echo "Dark mode"
else
    echo '' > $isdarkmode_file
    echo "Light mode"
fi

## Hyprwm
HYPRLAND_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"
HYPRLAND_override_darkmode_file="$HYPRLAND_CONFIG_DIR/.import-darkmode_cache.conf"
if [ "$DARKMODE_ENABLE" = true ]; then
    echo 'source = .overrides_darkmode.conf' > $HYPRLAND_override_darkmode_file
else
    echo '' > $HYPRLAND_override_darkmode_file
fi

## Waybar
WAYBAR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
WAYBAR_override_darkmode_file="$WAYBAR_CONFIG_DIR/.import-darkmode_cache.css"
if [ "$DARKMODE_ENABLE" = true ]; then
    echo '@import url("style-darkmode.css");' > $WAYBAR_override_darkmode_file
else
    echo '' > $WAYBAR_override_darkmode_file
fi

## Rofi
ROFI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/rofi"
ROFI_override_darkmode_file="$ROFI_CONFIG_DIR/.import-darkmode_cache.rasi"
if [ "$DARKMODE_ENABLE" = true ]; then
    echo '@theme "style-dark"' > $ROFI_override_darkmode_file
else
    echo '' > $ROFI_override_darkmode_file
fi

## Wlogout
WLOGOUT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wlogout"
WLOGOUT_override_darkmode_file="$WLOGOUT_CONFIG_DIR/.import-darkmode_cache.css"
if [ "$DARKMODE_ENABLE" = true ]; then
    echo '@import url("style-darkmode.css");' > $WLOGOUT_override_darkmode_file
else
    echo '' > $WLOGOUT_override_darkmode_file
fi

## Wallpaper slideshow update
if [ "$UPDATE_WALLPAPER_SLIDESHOW" = true ]; then
    isdarkmode_wallpaper_file=".is-darkmode-wallpaper_cache"
    if [ "$DARKMODE_ENABLE" = true ]; then
        if [ ! -f "$isdarkmode_wallpaper_file" ] || ! grep -q '[^[:space:]]' "$isdarkmode_wallpaper_file"; then
            echo "Setting dark wallpaper slideshow"
            ./start-wallpaper-slideshow.sh --force
        fi
    else
        if [ -f "$isdarkmode_wallpaper_file" ] && grep -q '[^[:space:]]' "$isdarkmode_wallpaper_file"; then
            echo "Setting light wallpaper slideshow"
            ./start-wallpaper-slideshow.sh --force
        fi
    fi
fi

## GTK etc
if [ "$DARKMODE_ENABLE" = true ]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
fi