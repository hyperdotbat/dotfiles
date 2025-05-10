#!/bin/bash
cd "$(dirname "$0")" || exit 1

SCRIPT_NAME="hyprsunset.sh"

if pgrep -f "$SCRIPT_NAME" > /dev/null; then
    if [ "$1" == "--dry-run" ]; then
        echo 0
        exit 0
    fi
    pkill -f "$SCRIPT_NAME"

    echo 0
    exit 0
else
    if [ "$1" == "--dry-run" ]; then
        echo 1
        exit 1
    fi
    nohup "./$SCRIPT_NAME" > /dev/null 2>&1 &
    disown
    
    echo 1
    exit 1
fi
