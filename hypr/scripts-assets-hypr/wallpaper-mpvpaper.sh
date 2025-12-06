#!/bin/bash
cd "$(dirname "$0")" || exit 1

pids=$(pgrep mpvpaper)

PARAMS="no-audio loop --video-unscaled=no"
MONITOR1_PARAMS="--vf=scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080"
MONITOR2_PARAMS="--vf=scale=ceil(1920*iw/ih/2)*2:1920:flags=lanczos,crop=1200:1920" # vertical
MONITOR1="DP-2"
MONITOR2="DP-1"

mpvpaper -vs -o "$PARAMS $MONITOR1_PARAMS" -f "$MONITOR1" "$1"

if [ $MONITOR2 != "" ]; then
    mpvpaper -vs -o "$PARAMS $MONITOR2_PARAMS" -f $MONITOR2 "$1"
fi

sleep 0.4
if [ -n "$pids" ]; then
    kill $pids
fi