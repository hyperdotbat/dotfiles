#!/bin/bash
FOCUSED_CLASS=$(hyprctl activewindow -j | jq -r '.class')
if [[ "$FOCUSED_CLASS" == Minecraft* ]]; then
    ydotool key 42:1 61:1 61:0 42:0
else
    ydotool key 0x114:1
fi