#!/bin/bash
cd "$(dirname "$0")" || exit 1

USE_NERD_FONT_ICONS=true

_text_pick_wallpaper_from_slideshow="Pick Wallpaper from Slideshow"
_text_dim_displays="Dim All Displays"

_text_toggle_wallpaper_slideshow="Toggle Wallpaper Slideshow"
if [ "$(./toggle-wallpaper-slideshow.sh '--dry-run')" -eq 0 ]; then
    _text_toggle_wallpaper_slideshow+=" (is On)"
else
    _text_toggle_wallpaper_slideshow+=" (is Off)"
fi

_text_pick_wallpaper_animated="Pick Wallpaper Animated"

_text_toggle_darkmode_daemon="Toggle Darkmode Daemon"
if [ "$(./toggle-darkmode-daemon.sh '--dry-run')" -eq 0 ]; then
    _text_toggle_darkmode_daemon+=" (is On)"
else
    _text_toggle_darkmode_daemon+=" (is Off)"
fi

_text_toggle_hyprsunset_daemon="Toggle Hyprsunset Daemon"
if [ "$(./toggle-hyprsunset-daemon.sh '--dry-run')" -eq 0 ]; then
    _text_toggle_hyprsunset_daemon+=" (is On)"
else
    _text_toggle_hyprsunset_daemon+=" (is Off)"
fi

_text_toggle_grayscale="Toggle Grayscale"
if [ "$(hyprshade current)" = "grayscale" ]; then
    _text_toggle_grayscale+=" (is On)"
else
    _text_toggle_grayscale+=" (is Off)"
fi

_text_ssh="Open SSH"
_text_update="Update system"


options=(
    "$_text_pick_wallpaper_from_slideshow"
    "$_text_toggle_wallpaper_slideshow"
    "$_text_pick_wallpaper_animated"
    "$_text_toggle_darkmode_daemon"
    "$_text_toggle_hyprsunset_daemon"
    "$_text_toggle_grayscale"
    "$_text_dim_displays"
    "$_text_ssh"
    "$_text_update"
)

r_override=""
rofi_override_file=".rofi_launcher_override.rasi"
if [ -f "$rofi_override_file" ]; then
    r_override=$(<$rofi_override_file)
fi
if [ "$USE_NERD_FONT_ICONS" = true ]; then
    r_override+="""
* {
    font: 'JetBrainsMono Nerd Font 12';
}
"""
fi
# change width based on aspect ratio
x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
transform=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .transform')
if [[ "$transform" == "1" || "$transform" == "3" ]]; then
    tmp=$x_monres
    x_monres=$y_monres
    y_monres=$tmp
fi
aspect_r=$((x_monres * 10 / y_monres))
if (( aspect_r < 10 )); then
    R_WIDTH=64
    R_HEIGHT=28
    r_override+="#window { width: ${R_WIDTH}%; height: ${R_HEIGHT}%; }"
fi


SELECTED=$(printf "%s\n" "${options[@]}" | rofi -dmenu -theme-str "$r_override" -markup-rows -i -p "" -me-select-entry '' -me-accept-entry 'MousePrimary')

killall rofi
case "$SELECTED" in
    "$_text_pick_wallpaper_from_slideshow")
        ./wallpaper_picker_slideshow.sh
        ;;
    "$_text_toggle_wallpaper_slideshow")
        ./toggle-wallpaper-slideshow.sh
        ;;
    "$_text_pick_wallpaper_animated")
        ./wallpaper_picker_animated.sh
        ;;
    "$_text_toggle_darkmode_daemon")
        ./toggle-darkmode-daemon.sh
        ;;
    "$_text_toggle_hyprsunset_daemon")
        ./toggle-hyprsunset-daemon.sh
        ;;
    "$_text_toggle_grayscale")
        hyprshade toggle grayscale
        ;;
    "$_text_dim_displays")
        ./sunshine.sh
        ;;
    "$_text_ssh")
        ./rofi-launcher-submenu_ssh.sh
        ;;
    "$_text_update")
        ./update-system.sh
        ;;
esac
exit 0
