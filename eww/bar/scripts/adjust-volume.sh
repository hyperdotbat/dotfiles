#!/bin/bash

DIRECTION=$1

if [[ $DIRECTION == "up" ]]; then
	~/.config/hypr/scripts/volumecontrol.sh -o i
elif [[ $DIRECTION == "down" ]]; then
	~/.config/hypr/scripts/volumecontrol.sh -o d
fi
