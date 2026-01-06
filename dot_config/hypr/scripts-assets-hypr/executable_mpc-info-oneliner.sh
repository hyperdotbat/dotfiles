#!/bin/bash

MAX_LEN=30
DISPLAY_TIMESTAMP_TO_LEFT=true

status=$(mpc status 2>/dev/null | awk 'NR==2 {print $1}')

if [[ "$status" == ERROR:* ]] || [[ -z "$status" ]]; then
    # MPD is stopped or not running
    echo " MPD Stopped"
    exit 0
fi

case "$status" in
    "[playing]")
        icon=""   # Nerd Font play icon
        ;;
    "[paused]")
        icon=""   # Nerd Font pause icon
        ;;
    *)
        icon=""
        ;;
esac

artist_title=$(mpc --format "%artist% - %title%" current)
time=$(mpc status | awk 'NR==2 {print $3}' | sed 's/\// \/ /')

if [ "$DISPLAY_TIMESTAMP_TO_LEFT" = "true" ]; then
    echo "$icon [$time] $artist_title"
else
    if [ $MAX_LEN -gt 0 ] && [ ${#artist_title} -gt $MAX_LEN ]; then
        artist_title="${artist_title:0:$MAX_LEN}..."
    fi

    echo "$icon $artist_title [$time]"
fi