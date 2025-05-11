#!/bin/bash
SEPERATE_DARKMODE_DIR=true #currently split through with start-wallpaper-slideshow.sh

wallpapers_dir_file=".wallpapers_dir_slideshow"
isdarkmode_file=".is-darkmode_cache"

wallpapers_dir=""
isdarkmode=false

if [ -f "$isdarkmode_file" ] && grep -q '[^[:space:]]' "$isdarkmode_file"; then
    isdarkmode=true
fi

if [ "$SEPERATE_DARKMODE_DIR" = true ] && [ "$isdarkmode" = true ]; then
    wallpapers_darkmode_dir_file=".wallpapers_dir_slideshow_dark"
    if [ -f "$wallpapers_darkmode_dir_file" ]; then
        wallpapers_dir=$(<$wallpapers_darkmode_dir_file)
    fi
else
    if [ -f "$wallpapers_dir_file" ]; then
        wallpapers_dir=$(<$wallpapers_dir_file)
    fi
fi
echo $wallpapers_dir
