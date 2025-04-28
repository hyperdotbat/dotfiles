#!/bin/bash
cd "$(dirname "$0")" || exit 1

WALLPAPERS_DIR_OG="~/Pictures/Wallpapers"
wallpapers_dir_file=".wallpapers_dir"
if [ -f "$wallpapers_dir_file" ]; then
    WALLPAPERS_DIR_OG=$(<$wallpapers_dir_file)
else
    echo "$WALLPAPERS_DIR_OG" > "$wallpapers_dir_file"
fi

WALLPAPERS_DIR="${WALLPAPERS_DIR_OG/#\~/$HOME}"
WALLPAPERS_DIR="${WALLPAPERS_DIR%/}"

WALLPAPER_CURRENT="Abstract/nord-shards.png"
wallpaper_current_path=".wallpaper_current_path_cache"
if [ -f "$wallpaper_current_path" ]; then
    WALLPAPER_CURRENT=$(<$wallpaper_current_path)
else
    echo "" > "$wallpaper_current_path"
    echo "WALLPAPER_CURRENT is empty"
    exit 1
fi

if [[ -z "$WALLPAPER_CURRENT" || "$WALLPAPER_CURRENT" =~ ^[[:space:]]*$ ]]; then
    echo "WALLPAPER_CURRENT is empty"
    exit 1
fi

./wallpaper_set.sh "$WALLPAPERS_DIR/$WALLPAPER_CURRENT"
