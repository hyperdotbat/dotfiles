#!/bin/bash
cd "$(dirname "$0")" || exit 1

WALLPAPER_TOOL="hyprpaper"
wallpaper_tool_file=".wallpaper_set_tool"
if [ -f "$wallpaper_tool_file" ]; then
    WALLPAPER_TOOL=$(<$wallpaper_tool_file)
else
    echo "$WALLPAPER_TOOL" > "$wallpaper_tool_file"
fi

if [ "$WALLPAPER_TOOL" == "swww" ]; then
    swww-daemon &
fi
if [ "$WALLPAPER_TOOL" == "hyprpaper" ]; then
    hyprpaper &
fi