#!/bin/bash
export LC_NUMERIC=C
IS_URGENT_ABOVE=100

OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
if echo "$OUTPUT" | grep -q "\[MUTED\]"; then
    notify-send -a volume -u normal -t 1000 --replace-id=999 -i audio-volume-muted "Muted"
    exit 1
fi

VOLUME=$(printf "%.0f" "$(echo "$OUTPUT" | awk '{print $2 * 100}')")

icon=audio-volume-medium
if [ "$VOLUME" -gt 70 ]; then
    icon=audio-volume-high
elif [ "$VOLUME" -lt 30 ]; then
    icon=audio-volume-low
fi
if [ "$VOLUME" = 0 ]; then
    icon=audio-volume-muted
fi

if [ "$VOLUME" -gt "$IS_URGENT_ABOVE" ]; then
    urgency=critical
else
    urgency=low
fi

notify-send -a volume -u "$urgency" -t 1000 --replace-id=999 -i "$icon" "$VOLUME%"