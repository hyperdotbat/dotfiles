#!/bin/bash
cd "$(dirname "$0")" || exit 1

MONITOR="DP-2"

SAVE_DIR="$HOME/Videos/Recordings"
OUTPUT="$SAVE_DIR/$(date '+%Y-%m-%d_%H-%M-%S').mp4"
COPY_TO_CLIPBOARD="true"

START_SFX="recording_start.mp3"
END_SFX="recording_end.mp3"

if pgrep -x wf-recorder > /dev/null; then
    if [ -n "$END_SFX" ]; then
        play "$END_SFX" vol 0.1
    fi
    killall wf-recorder
else
    if [ -n "$START_SFX" ]; then
        play "$START_SFX" vol 0.1
    fi
    if [ "$COPY_TO_CLIPBOARD" = "true" ]; then
        wf-recorder -o "$MONITOR" -f "$OUTPUT" && \
        printf 'file://%s\n' "$(realpath "$OUTPUT")" | wl-copy --type text/uri-list
    else
        wf-recorder -o "$MONITOR" -f "$OUTPUT"
    fi
fi