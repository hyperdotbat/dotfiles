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
_text_more="------------" #"More options..."

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

## more options
_text_pick_wallpaper_from_slideshow="Pick Wallpaper from Slideshow"

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

_text_dim_displays="Dim All Displays"
_text_display_100="Set brightness to 100%"
# _text_display_m20="Set brightness -20%"
# _text_display_p20="Set brightness +20%"
_text_display_50="Set brightness to 50%"
_text_display_0="Set brightness to 0%"
_text_hyprsnow="Toggle Hyprsnow"

_text_ssh="Open SSH"
_text_update="Update system"

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

    ## more options
    "$_text_more"
    "$_text_pick_wallpaper_from_slideshow"
    "$_text_toggle_wallpaper_slideshow"
    "$_text_pick_wallpaper_animated"
    "$_text_toggle_darkmode_daemon"
    "$_text_toggle_hyprsunset_daemon"
    "$_text_toggle_grayscale"
    # "$_text_dim_displays"
    "$_text_display_100"
    "$_text_display_50"
    "$_text_display_0"
    "$_text_hyprsnow"
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

    # "$_text_more")
    #     ./rofi-launcher-submenu_settings.sh &
    ## more options

    "$_text_logout_menu")
        wlogout &
        ;;
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
    "$_text_display_100")
        ddcutil setvcp 10 100
        ;;
    "$_text_display_50")
        ddcutil setvcp 10 50
        ;;
    "$_text_display_0")
        ddcutil setvcp 10 0
        ;;
    "$_text_hyprsnow")
        ./toggle_hyprsnow.sh
        ;;
    "$_text_ssh")
        ./rofi-launcher-submenu_ssh.sh
        ;;
    "$_text_update")
        ./update-system.sh
        ;;
esac

disown
exit 0