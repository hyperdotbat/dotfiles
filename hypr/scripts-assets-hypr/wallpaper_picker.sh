#!/bin/bash
cd "$(dirname "$0")" || exit 1

WALLPAPER_SET_SCRIPT="./wallpaper_set_save.sh"

WALLPAPERS_DIR_OG="~/Pictures/Wallpapers"
wallpapers_dir_file=".wallpapers_dir"
if [ -f "$wallpapers_dir_file" ]; then
    WALLPAPERS_DIR_OG=$(<$wallpapers_dir_file)
else
    echo "$WALLPAPERS_DIR_OG" > "$wallpapers_dir_file"
fi

WALLPAPERS_DIR="${WALLPAPERS_DIR_OG/#\~/$HOME}"
WALLPAPERS_DIR="${WALLPAPERS_DIR%/}"

#mapfile -t WALLPAPERS < <(find -L "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sed "s|$WALLPAPERS_DIR/||" | sort)
# if tool = swww
mapfile -t WALLPAPERS < <(find -L "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | sed "s|$WALLPAPERS_DIR/||" | sort)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "No wallpapers found!"
    exit 1
fi

SELECTED=$(printf '%s\n' "${WALLPAPERS[@]}" | rofi -dmenu -p "Pick a wallpaper")

if [[ -n "$SELECTED" ]]; then
    WALLPAPER="$WALLPAPERS_DIR/$SELECTED"
    "$WALLPAPER_SET_SCRIPT" "$WALLPAPER"
else
    echo "No wallpaper selected."
fi

