#!/bin/bash
cliphist list | rofi -dmenu -p "cliphist" | cliphist decode | wl-copy
