#!/bin/bash
mode=${1:-"drun"}
if pgrep -x rofi; then
    killall rofi
else
    # rofi -normal-window -show "$mode"
    rofi -show "$mode" -modes combi,window,drun,run,ssh -combi-modes "window,drun,run,ssh"
fi
