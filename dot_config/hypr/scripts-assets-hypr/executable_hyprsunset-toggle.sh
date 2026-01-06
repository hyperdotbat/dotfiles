#!/bin/bash
TEMPERATURE=5000

if pgrep -x hyprsunset > /dev/null; then
    # hyprctl hyprsunset identity
    killall hyprsunset
    echo "Disabled hyprsunset"
    exit 0
fi
if ! pgrep -x hyprsunset > /dev/null; then
#     hyprctl hyprsunset temperature "$TEMPERATURE"
#     exit 0
# else
    hyprsunset --temperature "$TEMPERATURE" &
    echo "Applied hyprsunset"
    exit 0
fi
