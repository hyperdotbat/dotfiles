#!/bin/bash
if pgrep -x hyprsnow > /dev/null; then
    killall hyprsnow
else
    hyprsnow &
fi