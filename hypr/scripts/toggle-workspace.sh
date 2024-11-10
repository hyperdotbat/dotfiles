#!/bin/bash

numparam=$1

cur_workspace=`hyprctl activeworkspace -j | jq -r '.name'`

if [ "$cur_workspace" == "$numparam" ]; then
	hyprctl dispatch workspace previous
else
	hyprctl dispatch workspace "$numparam"
fi
