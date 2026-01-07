#!/bin/bash
cd "$(dirname "$0")" || exit 1

rofi -modi "processes:~/.config/rofi/rofi-process-killer.sh" -show processes -theme-str 'element-text {wrap: true;} window {width: 95%;}'