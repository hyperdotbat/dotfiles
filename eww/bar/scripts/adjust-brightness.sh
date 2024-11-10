#!/bin/bash

# if [[ $EWW_SCROLL_DIRECTION == "up" ]]; then
# 	~/.config/hypr/scripts/brightnesscontrol.sh i
# elif [[ $EWW_SCROLL_DIRECTION == "down" ]]; then
# 	~/.config/hypr/scripts/brightnesscontrol.sh d
# fi

DIRECTION=$1

if [[ $DIRECTION == "up" ]]; then
	~/.config/hypr/scripts/brightnesscontrol.sh i
elif [[ $DIRECTION == "down" ]]; then
	~/.config/hypr/scripts/brightnesscontrol.sh d
fi
