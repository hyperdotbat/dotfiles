#!/bin/bash
WALLPAPERS_DIR="$HOME/Pictures/Wallpapers"
WALLPAPERS_DIR=($(./get_current_wallpaper_slideshow_dir.sh))
if ./wallpaper_picker.sh "$WALLPAPERS_DIR"; then
    ./start-wallpaper-slideshow.sh --update
    exit 0
fi
exit 1