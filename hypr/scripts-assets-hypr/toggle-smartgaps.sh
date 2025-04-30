#!/bin/bash
cd "$(dirname "$0")" || exit 1
override_smartgaps_file="../.override_smartgaps.conf"
SMART_GAPS_ENABLED=false
if [ -f "$override_smartgaps_file" ] && grep -q '[^[:space:]]' "$override_smartgaps_file"; then
    SMART_GAPS_ENABLED=true
fi

if [ -n "$1" ]; then
    if [ "$1" = "true" ] || [ "$1" = "1" ]; then
        SMART_GAPS_ENABLED=false
    elif [ "$1" = "false" ] || [ "$1" = "0" ]; then
        SMART_GAPS_ENABLED=true
    fi
fi


if [ "$SMART_GAPS_ENABLED" = false ]; then
    echo 'source = look-and-feel_smartgaps.conf' > $override_smartgaps_file
else
    echo '' > $override_smartgaps_file
fi