#!/bin/bash

if [ "$IS_LIGHT_THEME" ]; then
	if [ "$IS_LIGHT_THEME" == "1" ]; then
		"./system-set-theme.sh" "0"
	else
		"./system-set-theme.sh" "1"
	fi
else
	export $IS_LIGHT_THEME = "0"
	"./system-set-theme.sh" "0"
fi
