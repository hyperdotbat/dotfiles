#!/bin/bash
cd "$(dirname "$0")" || exit 1
LOCK_ON_SUSPEND=true

if [ -n "$1" ]; then
    if [ "$1" = "--lock" ]; then
        LOCK_ON_SUSPEND=true
    fi
    if [ "$1" = "--no-lock" ]; then
        LOCK_ON_SUSPEND=false
    fi
fi

WALLPAPER_TOOL="hyprpaper"
wallpaper_tool_file=".wallpaper_set_tool"
if [ -f "$wallpaper_tool_file" ] && grep -q '[^[:space:]]' "$wallpaper_tool_file"; then
    WALLPAPER_TOOL=$(<$wallpaper_tool_file)
fi

wallpaper_restore() {
    if [ "$WALLPAPER_TOOL" = "swww" ]; then
        sleep 0.5 && swww restore
    fi
    # i actually have no clue if hyprpaper works with like secondary display restoring
}

if [ "$LOCK_ON_SUSPEND" = true ]; then
    hyprlock &
    pid=$!

    for i in {1..10}; do
        if pgrep -x hyprlock >/dev/null; then
            break
        fi
        sleep 0.2
    done
    sleep 0.1
    systemctl suspend && wallpaper_restore
else
    systemctl suspend && wallpaper_restore
fi