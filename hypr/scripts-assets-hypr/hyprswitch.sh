#!/bin/bash
if [ -z "$(pgrep -x 'hyprswitch')" ]; then
    hyprswitch init &
    sleep 0.2
fi
if [ -n "$1" ]; then
    hyprswitch gui --mod-key alt_l --key tab --close mod-key-release --reverse-key=mod=shift --sort-recent && hyprswitch dispatch -r
else
    hyprswitch gui --mod-key alt_l --key tab --close mod-key-release --reverse-key=mod=shift --sort-recent && hyprswitch dispatch
fi