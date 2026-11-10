#!/bin/bash
cd "$(dirname "$0")" || exit 1
smartgaps_import_file="../.import-smartgaps_cache.lua"
SMARTGAPS_ENABLED=false
if [ -f "$smartgaps_import_file" ] && grep -q '[^[:space:]]' "$smartgaps_import_file"; then
    SMARTGAPS_ENABLED=true
fi

if [ -n "$1" ]; then
    if [ "$1" = "true" ] || [ "$1" = "1" ]; then
        SMARTGAPS_ENABLED=false
    elif [ "$1" = "false" ] || [ "$1" = "0" ]; then
        SMARTGAPS_ENABLED=true
    fi
fi


if [ "$SMARTGAPS_ENABLED" = false ]; then
    echo 'require("./.overrides_smartgaps.lua")' > $smartgaps_import_file
else
    echo '' > $smartgaps_import_file
fi
