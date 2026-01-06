#!/bin/bash
IS_ENABLED=true
SUNSET_HOUR=21
SUNRISE_HOUR=7
TEMPERATURE=5000

applied=false

if [ "$IS_ENABLED" = true ]; then
    while true; do
        hour=$(date +%H)
        if [ "$hour" -ge "$SUNSET_HOUR" ] || [ "$hour" -lt "$SUNRISE_HOUR" ]; then
            if [ "$applied" = false ]; then
                if pgrep -x hyprsunset > /dev/null; then
                    hyprctl hyprsunset temperature "$TEMPERATURE"
                else
                    hyprsunset --temperature "$TEMPERATURE" &
                fi
                echo "Applied hyprsunset"
                applied=true
            fi
        fi

        if [ "$hour" -ge "$SUNRISE_HOUR" ] && [ "$hour" -lt "$SUNSET_HOUR" ]; then
            if [ "$applied" = true ]; then
                if pgrep -x hyprsunset > /dev/null; then
                    hyprctl hyprsunset identity
                fi
                echo "Disabled hyprsunset"
                applied=false
            fi
        fi
        sleep 60
    done
fi