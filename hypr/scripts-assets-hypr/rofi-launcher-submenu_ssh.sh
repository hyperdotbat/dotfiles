#!/bin/bash
cd "$(dirname "$0")" || exit 1

USE_NERD_FONT_ICONS=true

_text_homelab="Homelab"
_text_cenovo="Cenovo"
_text_komorebi="Komorebi"
_text_hoshizora="Hoshizora"

options=(
    "$_text_homelab"
    "$_text_cenovo"
    "$_text_komorebi"
    "$_text_hoshizora"
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
if [[ "$SELECTED" == "$_text_homelab" ]]; then
    kitty -e bash -i -c "ssh_homelab"
    exit 0
fi
if [[ "$SELECTED" == "$_text_cenovo" ]]; then
    kitty -e bash -i -c "ssh_cenovo"
    exit 0
fi
if [[ "$SELECTED" == "$_text_komorebi" ]]; then
    kitty -e bash -i -c "ssh_komorebi"
    exit 0
fi
if [[ "$SELECTED" == "$_text_hoshizora" ]]; then
    kitty -e bash -i -c "ssh_hoshizora"
    exit 0
fi
