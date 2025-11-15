#!/bin/bash
cd "$(dirname "$0")" || exit 1

USE_NERD_FONT_ICONS=true

_text_app_launcher="App Launcher"
_text_wallpaper_picker="Wallpaper Picker"
_text_window_switcher="Window Switcher"
_text_file_browser="File Browser"
_text_terminal="Terminal"
_text_hyprsunset="Hyprsunset"
_text_darkmode="Toggle darkmode"
_text_dotfiles="Configure dotfiles"
_text_logout_menu="Logout Menu"
_text_more="More options..."

# Show darkmode/lightmode based on whats currently enabled
_text_darkmode="Toggle "
isdarkmode_file=".is-darkmode_cache"
if [ -f "$isdarkmode_file" ] && grep -q '[^[:space:]]' "$isdarkmode_file"; then
    _text_darkmode+="lightmode"
else
    _text_darkmode+="darkmode"
fi

_text_mpd=$(./mpc-info-oneliner.sh)

if [ "$USE_NERD_FONT_ICONS" = true ]; then
    _text_app_launcher=" $_text_app_launcher"
    _text_wallpaper_picker=" $_text_wallpaper_picker"
    _text_window_switcher=" $_text_window_switcher"
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
    "$_text_window_switcher"
    "$_text_file_browser"
    "$_text_terminal"
    "$_text_hyprsunset"
    "$_text_darkmode"
    "$_text_dotfiles"
    "$_text_mpd"
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
    R_HEIGHT=30
    r_override+="#window { width: ${R_WIDTH}%; height: ${R_HEIGHT}%; }"
fi

if pgrep -x rofi; then
    killall rofi
    exit 0
fi

SELECTED=$(printf "%s\n" "${options[@]}" | rofi -dmenu -theme-str "$r_override" -markup-rows -i -p "" -me-select-entry '' -me-accept-entry 'MousePrimary')

killall rofi
case "$SELECTED" in
    "$_text_app_launcher")
        ./launch-rofi.sh &
        ;;
    "$_text_wallpaper_picker")
        ./wallpaper_picker.sh &
        ;;
    "$_text_window_switcher")
        ./hyprswitch.sh &
        # hyprswitch gui
        ;;
    "$_text_file_browser")
        xdg-open "$HOME" &
        ;;
    "$_text_terminal")
        x-terminal-emulator "$HOME" &
        ;;
    "$_text_hyprsunset")
        ./hyprsunset-toggle.sh &
        ;;
    "$_text_darkmode")
        ./toggle-darkmode.sh &
        ;;
    "$_text_dotfiles")
        code "$HOME/dotfiles" &
        ;;
    "$_text_mpd")
        mpc toggle
        ;;
    "$_text_logout_menu")
        wlogout &
        ;;
    "$_text_more")
        ./rofi-launcher-submenu_settings.sh &
        ;;
esac

disown
exit 0