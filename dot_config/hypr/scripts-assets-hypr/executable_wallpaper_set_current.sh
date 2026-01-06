#!/bin/bash
cd "$(dirname "$0")" || exit 1

WALLPAPERS_DIR_OG="~/Pictures/Wallpapers"
wallpapers_dir_file=".wallpapers_dir_cache"
if [ -f "$wallpapers_dir_file" ] && grep -q '[^[:space:]]' "$wallpapers_dir_file"; then
    WALLPAPERS_DIR_OG=$(<$wallpapers_dir_file)
else
    echo "$WALLPAPERS_DIR_OG" > "$wallpapers_dir_file"
fi

WALLPAPERS_DIR="${WALLPAPERS_DIR_OG/#\~/$HOME}"
WALLPAPERS_DIR="${WALLPAPERS_DIR%/}"

WALLPAPER_CURRENT="Nature-irl/stairs_everforest.jpg"
wallpaper_current_path=".wallpaper_current_path_cache"
if [ -f "$wallpaper_current_path" ] && grep -q '[^[:space:]]' "$wallpaper_current_path"; then
    WALLPAPER_CURRENT=$(<$wallpaper_current_path)
else
    touch "$wallpaper_current_path"
    echo "WALLPAPER_CURRENT is empty"
    exit 1
fi

if [[ -z "$WALLPAPER_CURRENT" || "$WALLPAPER_CURRENT" =~ ^[[:space:]]*$ ]]; then
    echo "WALLPAPER_CURRENT is empty"
    exit 1
fi

./wallpaper_set.sh "$WALLPAPERS_DIR/$WALLPAPER_CURRENT"
