#!/bin/sh

mode=${1:-"combi"}
if pgrep -x rofi; then
    killall rofi
else
    # rofi -normal-window -show "$mode"
    # rofi -show combi -modes combih -combi-modes "window,drun,run"
    rofi -show "$mode" -modes combi,window,drun,run,ssh -combi-modes "window,drun,run,ssh"
fi
