#!/bin/bash
cd "$(dirname "$0")" || exit 1

if [ -z "$1" ]; then
    echo "Provide path to wallpaper."
    exit 1
fi

WALLPAPER_FULL_PATH_OG=$1

./wallpaper_set.sh "$WALLPAPER_FULL_PATH_OG"

WALLPAPERS_DIR_OG="~/Pictures/Wallpapers/"
wallpapers_dir_file=".wallpapers_dir"
if [ -f "$wallpapers_dir_file" ]; then
    WALLPAPERS_DIR_OG=$(<$wallpapers_dir_file)
else
    echo "Cant save; .wallpapers_dir doesnt exist so cant compare paths."
    exit 1
fi
[[ "$WALLPAPERS_DIR_OG" != */ ]] && WALLPAPERS_DIR_OG="${WALLPAPERS_DIR_OG}/"

WALLPAPERS_DIR="${WALLPAPERS_DIR_OG/#\~/$HOME}"
WALLPAPER_FULL_PATH="${WALLPAPER_FULL_PATH_OG/#\~/$HOME}"

WALLPAPER_CURRENT=""
if [[ "$WALLPAPER_FULL_PATH" == "$WALLPAPERS_DIR"* ]]; then
    WALLPAPER_CURRENT="${WALLPAPER_FULL_PATH#$WALLPAPERS_DIR}"
else
    echo "Cant save; '$WALLPAPER_FULL_PATH' is not inside '$WALLPAPERS_DIR'" >&2
    exit 1
fi

wallpaper_current_path=".wallpaper_current_path_cache"
echo "$WALLPAPER_CURRENT" > "$wallpaper_current_path"

ln -sf "$(realpath $WALLPAPER)" ./.wallpaper_cache

echo "Saved $WALLPAPER_CURRENT as current wallpaper"
