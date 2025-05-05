#!/bin/bash
cd "$(dirname "$0")" || exit 1

IS_ENABLED=true
DARKMODE_HOUR=21
LIGHTMODE_HOUR=6

switched_to_darkmode=false

if [ "$IS_ENABLED" = true ]; then
    while true; do
        hour=$(date +%H)
        if [ "$hour" -ge "$DARKMODE_HOUR" ] || [ "$hour" -lt "$LIGHTMODE_HOUR" ]; then
            if [ "$switched_to_darkmode" = false ]; then
                ./toggle-darkmode.sh 1
                echo "Switched to darkmode"
                switched_to_darkmode=true
            fi
        fi

        if [ "$hour" -ge "$LIGHTMODE_HOUR" ] && [ "$hour" -lt "$DARKMODE_HOUR" ]; then
            if [ "$switched_to_darkmode" = true ]; then
                ./toggle-darkmode.sh 0
                echo "Switched to lightmode"
                switched_to_darkmode=false
            fi
        fi
        sleep 60
    done
fi
