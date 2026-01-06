#!/bin/bash
cd "$(dirname "$0")" || exit 1

if [ -z "$(pgrep -x 'hyprswitch')" ] || [ "$1" == "--init" ]; then
    hyprswitch init --size-factor=4 --custom-css "../themes/hyprswitch.css" &
    sleep 0.2
fi

FILTER_CURRENT_MONITOR=false
filter_monitor_flag=""

if [ "$FILTER_CURRENT_MONITOR" = true ]; then
    filter_monitor_flag="--filter-current-monitor"
fi

if [ -n "$1" ]; then
    if [ "$1" == "-w" ]; then
        # Workspace Switcher (currently bind disabled, works weird)
        hyprswitch gui --mod-key super --key tab --close mod-key-release --reverse-key=mod=shift --sort-recent --filter-current-monitor --switch-type=workspace && hyprswitch dispatch
    elif [ "$1" == "-wr" ]; then
        # Workspace Switcher - Reverse
        hyprswitch gui --mod-key super --key tab --close mod-key-release --reverse-key=mod=shift --sort-recent --filter-current-monitor --switch-type=workspace && hyprswitch dispatch -r
    elif [ "$1" == "-r" ]; then
        # Window Switcher - Reverse
        hyprswitch gui --mod-key alt_l --key tab --close mod-key-release --reverse-key=mod=shift --sort-recent $filter_monitor_flag && hyprswitch dispatch -r
    fi
else
    # Window Switcher
    hyprswitch gui --mod-key alt_l --key tab --close mod-key-release --reverse-key=mod=shift --sort-recent $filter_monitor_flag && hyprswitch dispatch
fi

# TODO: Add trapping of hyprswitch.css in themes to restart the daemon