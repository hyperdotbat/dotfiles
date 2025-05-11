#!/bin/bash
cd "$(dirname "$0")" || exit 1

USE_NERD_FONT_ICONS=true

_text_app_launcher="App Launcher"
_text_wallpaper_picker="Wallpaper Picker"
_text_file_browser="File Browser"
_text_terminal="Terminal"
_text_hyprsunset="Hyprsunset"
_text_darkmode="Toggle darkmode"
_text_dotfiles="Configure dotfiles"
_text_logout_menu="Logout Menu"
_text_more="More options..."

if [ "$USE_NERD_FONT_ICONS" = true ]; then
    _text_app_launcher=" $_text_app_launcher"
    _text_wallpaper_picker=" $_text_wallpaper_picker"
    _text_file_browser=" $_text_file_browser"
    _text_terminal=" $_text_terminal"
    _text_hyprsunset=" $_text_hyprsunset"
    _text_darkmode=" $_text_darkmode"
    _text_dotfiles=" $_text_dotfiles"
    _text_logout_menu=" $_text_logout_menu"
fi

options=(
    "$_text_app_launcher"
    "$_text_wallpaper_picker"
    "$_text_file_browser"
    "$_text_terminal"
    "$_text_hyprsunset"
    "$_text_darkmode"
    "$_text_dotfiles"
    "$_text_logout_menu"
    "$_text_more"
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

SELECTED=$(printf "%s\n" "${options[@]}" | rofi -dmenu -theme-str "$r_override" -markup-rows -i -p "" -me-select-entry '' -me-accept-entry 'MousePrimary')

killall rofi
if [[ "$SELECTED" == "$_text_app_launcher" ]]; then
    ./launch-rofi.sh &
    exit 0
fi
if [[ "$SELECTED" == "$_text_wallpaper_picker" ]]; then
    ./wallpaper_picker.sh &
    exit 0
fi
if [[ "$SELECTED" == "$_text_file_browser" ]]; then
    thunar ~ &
    exit 0
fi
if [[ "$SELECTED" == "$_text_terminal" ]]; then
    kitty $HOME &
    exit 0
fi
if [[ "$SELECTED" == "$_text_hyprsunset" ]]; then
    ./hyprsunset-toggle.sh &
    exit 0
fi
if [[ "$SELECTED" == "$_text_darkmode" ]]; then
    ./toggle-darkmode.sh &
    exit 0
fi
if [[ "$SELECTED" == "$_text_dotfiles" ]]; then
    code $HOME/dotfiles &
    exit 0
fi
if [[ "$SELECTED" == "$_text_logout_menu" ]]; then
    wlogout &
    exit 0
fi
if [[ "$SELECTED" == "$_text_more" ]]; then
    ./rofi-launcher-submenu_settings.sh &
    exit 0
fi

disown