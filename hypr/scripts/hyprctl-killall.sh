#!/bin/bash

# windows=$(hyprctl clients -j | jq -r '.[] | address')
# windows=$(hyprctl clients -j | jq -r '.[].address')
windows=$(hyprctl clients -j | jq -r '.[].pid')

for win in $windows; do
	# hyprctl dispatch killwindow address:$win
	# hyprctl dispatch killwindow pid:$win
	# hyprctl dispatch closewindow $win
	echo $win
	kill -9 $win
done
