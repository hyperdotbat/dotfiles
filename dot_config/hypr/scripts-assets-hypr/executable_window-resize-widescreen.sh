#!/bin/bash
FOCUS=$(hyprctl activewindow -j)
# Disable fullscreen
echo "$FOCUS" | jq -e '.fullscreen != 0' >/dev/null && hyprctl dispatch fullscreen
# Enable floating if needed
echo "$FOCUS" | jq -e '.floating == false' >/dev/null && hyprctl dispatch togglefloating
# hyprctl dispatch togglefloating
# Resize
hyprctl dispatch resizeactive exact 1920 280
# Disable floating if needed
echo "$FOCUS" | jq -e '.floating == true' >/dev/null && hyprctl dispatch togglefloating
# hyprctl dispatch togglefloating
# Enable pseudotile
echo "$FOCUS" | jq -e '.pseudo == false' >/dev/null || hyprctl dispatch pseudo