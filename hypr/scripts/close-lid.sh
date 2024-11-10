#!/bin/bash

do_suspend=false

if [ "$do_suspend" == true ]; then
	systemctl suspend
else
	brightnessctl set 0
fi
