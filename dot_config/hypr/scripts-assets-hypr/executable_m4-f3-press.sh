#!/bin/bash
FOCUSED_CLASS=$(hyprctl activewindow -j | jq -r '.class')
if [[ "$FOCUSED_CLASS" == Minecraft* ]]; then
    ydotool key 61:1
else
    ydotool key 0x113:1
fi