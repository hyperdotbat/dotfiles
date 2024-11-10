#!/bin/bash

is_light_theme=$1

if [ "$is_light_theme" == "0" ] || [ "$is_light_theme" == "false" ] || [ "$is_light_theme" == "dark"  ]; then
	export $IS_LIGHT_THEME "1"
	ln -sf ~/.config/eww/maincolortheme_dark.scss ~/.config/eww/maincolortheme.scss	
	gsettings set org.gnome.desktop.interface color-scheme prefer-dark
	gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
	lookandfeeltool -a org.kde.breezedark.desktop
	kitten themes --reload-in=all "Gruvbox Dark"
	echo "Dark theme"
else
	export $IS_LIGHT_THEME="0"
	ln -sf ~/.config/eww/maincolortheme_light.scss ~/.config/eww/maincolortheme.scss
	gsettings set org.gnome.desktop.interface color-scheme prefer-light
	gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
	lookandfeeltool -a org.kde.breeze.desktop
	kitten themes --reload-in=all "Gruvbox Light Soft"
	echo "Light theme"
fi
