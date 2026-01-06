#!/bin/bash
cd "$(dirname "$0")" || exit 1
nogaps_import_file="../.import-nogaps_cache.conf"
NOGAPS_ENABLED=false
if [ -f "$nogaps_import_file" ] && grep -q '[^[:space:]]' "$nogaps_import_file"; then
    NOGAPS_ENABLED=true
fi

if [ -n "$1" ]; then
    if [ "$1" = "true" ] || [ "$1" = "1" ]; then
        NOGAPS_ENABLED=false
    elif [ "$1" = "false" ] || [ "$1" = "0" ]; then
        NOGAPS_ENABLED=true
    fi
fi


if [ "$NOGAPS_ENABLED" = false ]; then
    echo 'source = .overrides_nogaps.conf' > $nogaps_import_file
else
    echo '' > $nogaps_import_file
fi