#!/bin/bash
cd "$(dirname "$0")" || exit 1

_text_pick_wallpaper_from_slideshow="Pick Wallpaper from Slideshow"

_text_toggle_wallpaper_slideshow="Toggle Wallpaper Slideshow"

if [ "$(./toggle-wallpaper-slideshow.sh '--dry-run')" -eq 0 ]; then
    _text_toggle_wallpaper_slideshow+=" (is On)"
else
    _text_toggle_wallpaper_slideshow+=" (is Off)"
fi

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


options=(
    "$_text_pick_wallpaper_from_slideshow"
    "$_text_toggle_wallpaper_slideshow"
    "$_text_toggle_darkmode_daemon"
    "$_text_toggle_hyprsunset_daemon"
)

r_override="""
configuration{
    eh: 1;
    hover-select: true;
    steal-focus: true;
    show-icons: false;
}
"""


SELECTED=$(printf "%s\n" "${options[@]}" | rofi -dmenu -theme-str "$r_override" -markup-rows -i -p "" -me-select-entry '' -me-accept-entry 'MousePrimary')

killall rofi
if [[ "$SELECTED" == "$_text_pick_wallpaper_from_slideshow" ]]; then
    ./wallpaper_picker_slideshow.sh
    exit 0
fi
if [[ "$SELECTED" == "$_text_toggle_wallpaper_slideshow" ]]; then
    ./toggle-wallpaper-slideshow.sh
    exit 0
fi
if [[ "$SELECTED" == "$_text_toggle_darkmode_daemon" ]]; then
    ./toggle-darkmode-daemon.sh
    exit 0
fi
if [[ "$SELECTED" == "$_text_toggle_hyprsunset_daemon" ]]; then
    ./toggle-hyprsunset-daemon.sh
    exit 0
fi
