#!/bin/bash
MAX_VOLUME=1.5
STEP=5
VOLUME_UP_UNMUTES=true

if [ -n "$1" ]; then
    if [ "$1" = "-" ]; then
        wpctl set-volume -l $MAX_VOLUME @DEFAULT_AUDIO_SINK@ $STEP%-
    elif [ "$1" = "+" ]; then
        wpctl set-volume -l $MAX_VOLUME @DEFAULT_AUDIO_SINK@ $STEP%+
        if [ "$VOLUME_UP_UNMUTES" = true ]; then
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        fi
    elif [ "$1" = "mute-toggle" ]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    elif [ "$1" = "mute" ]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
    elif [ "$1" = "unmute" ]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
fi