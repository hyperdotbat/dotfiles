#!/bin/bash
cd "$(dirname "$0")" || exit 1
pids=$(pgrep mpvpaper)

# TODO: would be neat to instantly play from CPU, create cache in the meantime and then replace on the fly
# caching made for different aspect ratio than original so 21:9 or vertical monitor
# its a decent idea to cache them since applying filters on CPU is slightly demanding
# but caching in turn takes a long time and a lot of space
CACHE_WALS=true
CACHE_EACH_ONE=false
MONITOR1="DP-2"
MONITOR2="DP-1" # set to empty if doesnt apply

CACHE_DIR="$HOME/.cache/wallpaper_thumbs"
mkdir -p "$CACHE_DIR"
CACHE_HASH="$CACHE_DIR/.last_mp4wallpaper"

MONITOR1_WAL_PATH="$1"
MONITOR2_WAL_PATH="$1"

PARAMS="no-audio loop --video-unscaled=no"
MONITOR1_MPV_PARAMS="--vf=scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080"
MONITOR2_MPV_PARAMS="--vf=scale=ceil(1920*iw/ih/2)*2:1920:flags=lanczos,crop=1200:1920" # vertical

MON2_CONNECTED=false
if [ -n "$MONITOR2" ]; then
    if mpvpaper -d | grep -q "$MONITOR2"; then
        MON2_CONNECTED=true
    else
        echo "Monitor 2 ($MONITOR2) not detected, skipping"
    fi
fi

# hardcoded skip caching & mpv effects for monitor 1 if video is already 16:9
WIDTH=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=p=0 "$1")
HEIGHT=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 "$1")
ASPECT=$(awk "BEGIN {print $WIDTH/$HEIGHT}")
SKIP_MON1=false
if (( $(echo "$ASPECT >= 1.77 && $ASPECT <= 1.79" | bc -l) )); then
    echo "video is already 16:9, using original / disabling mpv params for Monitor 1 ($MONITOR1)"
    SKIP_MON1=true
fi

if [ "$CACHE_WALS" = true ]; then
    MONITOR1_MPV_PARAMS=""
    MONITOR2_MPV_PARAMS=""
    MONITOR1_FFMPEG_PARAMS="scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080"
    MONITOR2_FFMPEG_PARAMS="scale=trunc(1920*iw/ih/2)*2:1920:flags=lanczos,crop=1200:1920" # vertical

    MONITOR1_WAL_PATH="$CACHE_DIR/monitor1.mp4"
    MONITOR2_WAL_PATH="$CACHE_DIR/monitor2.mp4"

    REGEN_CACHE=false
    if [ "$CACHE_EACH_ONE" = true ]; then
        filename=$(basename "$1")
        MONITOR1_WAL_PATH="$CACHE_DIR/${filename}_1.mp4"
        MONITOR2_WAL_PATH="$CACHE_DIR/${filename}_2.mp4"
        REGEN_CACHE=true
    else
        HASH=$(sha1sum "$1" | awk '{print $1}')
        LAST_HASH=""
        if [ -f "$CACHE_HASH" ]; then
            LAST_HASH=$(cat "$CACHE_HASH")
        fi
        if [ "$HASH" = "$LAST_HASH" ]; then
            # hash matches, but ensure the actual cache files exist for the monitors that need them
            M1_OK=true
            M2_OK=true
            if [ "$SKIP_CACHE_MON1" = false ]; then
                [ -f "$MONITOR1_WAL_PATH" ] || M1_OK=false
            fi
            if [ -n "$MONITOR2" ] && [ "$MON2_CONNECTED" = true ]; then
                [ -f "$MONITOR2_WAL_PATH" ] || M2_OK=false
            fi

            if [ "$M1_OK" = true ] && [ "$M2_OK" = true ]; then
                echo "same video, cache is valid."
                REGEN_CACHE=false
            else
                echo "matching hash but cache files missing - refresh cache."
                REGEN_CACHE=true
            fi
        else
            echo "new video, cache refresh."
            REGEN_CACHE=true
            echo "$HASH" > "$CACHE_HASH"
        fi
    fi

    if [ "$REGEN_CACHE" = true ]; then
        if [ "$CACHE_EACH_ONE" = false ]; then
            [ -f "$MONITOR1_WAL_PATH" ] && [ "$SKIP_MON1" = false ] && rm "$MONITOR1_WAL_PATH"
            [ -f "$MONITOR2_WAL_PATH" ] && [ "$MON2_CONNECTED" = true ] && rm "$MONITOR2_WAL_PATH"
        fi

        if [ "$SKIP_MON1" = false ]; then
            ffmpeg -i "$1" -vf "$MONITOR1_FFMPEG_PARAMS" -c:v libx264 -crf 18 -preset veryfast "$MONITOR1_WAL_PATH"
        fi

        if [ -n "$MONITOR2" ] && [ "$MON2_CONNECTED" = true ]; then
            ffmpeg -i "$1" -vf "$MONITOR2_FFMPEG_PARAMS" -c:v libx264 -crf 18 -preset veryfast "$MONITOR2_WAL_PATH"
        fi
    fi
fi

if [ "$SKIP_MON1" = true ]; then
    MONITOR1_WAL_PATH="$1"
    MONITOR1_MPV_PARAMS=""
fi

mpvpaper -vs -o "$PARAMS $MONITOR1_MPV_PARAMS" -f "$MONITOR1" "$MONITOR1_WAL_PATH"

if [ -n "$MONITOR2" ] && [ "$MON2_CONNECTED" = true ]; then
    mpvpaper -vs -o "$PARAMS $MONITOR2_MPV_PARAMS" -f "$MONITOR2" "$MONITOR2_WAL_PATH"
fi

sleep 0.4
if [ -n "$pids" ]; then
    kill $pids
fi