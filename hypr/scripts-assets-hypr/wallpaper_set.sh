#!/bin/bash
cd "$(dirname "$0")" || exit 1

WALLPAPER_TOOL="hyprpaper"
wallpaper_tool_file=".wallpaper_set_tool"
if [ -f "$wallpaper_tool_file" ]; then
    WALLPAPER_TOOL=$(<$wallpaper_tool_file)
else
    echo "$WALLPAPER_TOOL" > "$wallpaper_tool_file"
fi

WALLPAPER="$1"

if [ -z "$1" ]; then
    echo "Provide path to wallpaper."
    exit 1
fi


if [ "$WALLPAPER_TOOL" == "swww" ]; then
    SWWW_TRANSITION_TYPE="grow"
    SWWW_TRANSITION_DURATION=2
    SWWW_TRANSITION_FPS=60 #165

    if ! swww img "$WALLPAPER" \
	    --transition-type "$SWWW_TRANSITION_TYPE" \
	    --transition-duration "$SWWW_TRANSITION_DURATION" \
	    --transition-fps "$SWWW_TRANSITION_FPS" \
	    --resize=crop \
    ; then
        echo "Failed to set wallpaper: $WALLPAPER"
        exit 1
    fi
fi
if [ "$WALLPAPER_TOOL" == "hyprpaper" ]; then
    HYPRPAPER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprpaper.conf"

    if ! hyprctl hyprpaper preload "$WALLPAPER"; then
        echo "Failed to preload wallpaper: $WALLPAPER"
        exit 1
    fi

    hyprctl hyprpaper wallpaper DP-1,"$WALLPAPER"
    hyprctl hyprpaper wallpaper DP-2,"$WALLPAPER"

    cat > "$HYPRPAPER_CONFIG" <<EOF
preload = $WALLPAPER
wallpaper = DP-1,$WALLPAPER
wallpaper = DP-2,$WALLPAPER
EOF
fi
