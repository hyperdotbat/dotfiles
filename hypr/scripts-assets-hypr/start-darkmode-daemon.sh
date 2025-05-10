#!/bin/bash
cd "$(dirname "$0")" || exit 1

IS_ENABLED=true
DARKMODE_HOUR=21
LIGHTMODE_HOUR=6

isdarkmode_enabled=false

isdarkmode_file=".is-darkmode_cache"

if [ "$IS_ENABLED" = true ]; then
    while true; do
        if [ -f "$isdarkmode_file" ] && grep -q '[^[:space:]]' "$isdarkmode_file"; then
            isdarkmode_enabled=true
        fi

        hour=$(date +%H)
        if [ "$hour" -ge "$DARKMODE_HOUR" ] || [ "$hour" -lt "$LIGHTMODE_HOUR" ]; then
            if [ "$isdarkmode_enabled" = false ]; then
                ./toggle-darkmode.sh 1
                echo "Switched to darkmode"
                isdarkmode_enabled=true
            fi
        fi

        if [ "$hour" -ge "$LIGHTMODE_HOUR" ] && [ "$hour" -lt "$DARKMODE_HOUR" ]; then
            if [ "$isdarkmode_enabled" = true ]; then
                ./toggle-darkmode.sh 0
                echo "Switched to lightmode"
                isdarkmode_enabled=false
            fi
        fi
        sleep 60
    done
fi
