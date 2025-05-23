#!/bin/bash
cd "$(dirname "$0")" || exit 1

## Script executed when connecting/disconnecting from sunshine to disable second screen and dim main

monitors_import_file="../.import-monitors_cache.conf"
CONNECTED=false
if [ -f "$monitors_import_file" ] && grep -q '[^[:space:]]' "$monitors_import_file"; then
    CONNECTED=true
fi

if [ -n "$1" ]; then
    if [ "$1" = "true" ] || [ "$1" = "1" ]; then
        CONNECTED=false
    elif [ "$1" = "false" ] || [ "$1" = "0" ]; then
        CONNECTED=true
    fi
fi

# sleep 1
if [ "$CONNECTED" = false ]; then
    echo 'monitor = $monitorSecond, disable' > $monitors_import_file
    nohup hyprsunset --gamma 0 > /dev/null 2>&1 &
    disown
    echo "Connected"
else
    echo '' > $monitors_import_file
    killall hyprsunset
    ./wallpaper_set_current.sh
    echo "Disconnected"
fi