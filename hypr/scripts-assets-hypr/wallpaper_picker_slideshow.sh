#!/bin/bash
cd "$(dirname "$0")" || exit 1

WALLPAPERS_DIR="$HOME/Pictures/Wallpapers"
WALLPAPERS_DIR=($(./get_current_wallpaper_slideshow_dir.sh))
if [ -n "$1" ]; then
    if [ "$1" = "--light" ] || [ "$1" = "-l" ]; then
        wallpapers_dir_file=".wallpapers_dir_slideshow"
        if [ -f "$wallpapers_dir_file" ] && grep -q '[^[:space:]]' "$wallpapers_dir_file"; then
            WALLPAPERS_DIR=$(<$wallpapers_dir_file)
        fi
    elif [ "$1" = "--dark" ] || [ "$1" = "-d" ]; then
        wallpapers_darkmode_dir_file=".wallpapers_dir_slideshow_dark"
        if [ -f "$wallpapers_darkmode_dir_file" ] && grep -q '[^[:space:]]' "$wallpapers_darkmode_dir_file"; then
            WALLPAPERS_DIR=$(<$wallpapers_darkmode_dir_file)
        fi
    else
        echo "For specifying use --dark (-d) or --light (-l)"
        exit 1
    fi
fi

if ./wallpaper_picker.sh "$WALLPAPERS_DIR"; then
    ./start-wallpaper-slideshow.sh --update
    exit 0
fi
exit 1
