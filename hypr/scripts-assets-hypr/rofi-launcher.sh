#!/bin/bash
cd "$(dirname "$0")" || exit 1

_text_app_launcher="App Launcher"
_text_wallpaper_picker="Wallpaper Picker"
_text_terminal="Terminal"
_text_hyprsunset="Hyprsunset"
_text_darkmode="Toggle darkmode"
_text_dotfiles="Configure dotfiles"
_text_logout_menu="Logout Menu"
_text_more="More options..."
options=(
    "$_text_app_launcher"
    "$_text_wallpaper_picker"
    "$_text_terminal"
    "$_text_hyprsunset"
    "$_text_darkmode"
    "$_text_dotfiles"
    "$_text_logout_menu"
    "$_text_more"
)
# icons=(
#   " "
#   " "
#   " "
#   " "
#   "  "
#   "  "
#   " "
#   " "
# )

# entries=""
# fixed_width=3
# for i in "${!options[@]}"; do
#     icon=$(printf "%-${fixed_width}s" "${icons[$i]}")
#     # entries+="$icon\x00icon\x1f${options[$i]}"
#     # entries+="${options[$i]}\x00icon\x1f${icons[$i]}"
#     # entries+="${icons[$i]}${options[$i]}"
#     entries+="$icon${options[$i]}"
#     # entries+="${options[$i]}\x00icon\x1f$icon"

#     if [[ $i -lt $((${#options[@]} - 1)) ]]; then
#         entries+="\n"
#     fi
# done

r_override="""
configuration{
    eh: 1;
    hover-select: true;
    steal-focus: true;
    show-icons: false;
}
"""

SELECTED=$(printf "%s\n" "${options[@]}" | rofi -dmenu -theme-str "$r_override" -markup-rows -i -p "" -me-select-entry '' -me-accept-entry 'MousePrimary')
# SELECTED=$(echo -e "$entries" | rofi -dmenu -theme-str "$r_override" -markup-rows -i -p "" -me-select-entry '' -me-accept-entry 'MousePrimary')

killall rofi
if [[ "$SELECTED" == "$_text_app_launcher" ]]; then
    ./launch-rofi.sh
    exit 0
fi
if [[ "$SELECTED" == "$_text_wallpaper_picker" ]]; then
    ./wallpaper_picker.sh
    exit 0
fi
if [[ "$SELECTED" == "$_text_hyprsunset" ]]; then
    ./hyprsunset-toggle.sh
    exit 0
fi
if [[ "$SELECTED" == "$_text_darkmode" ]]; then
    ./toggle-darkmode.sh
    exit 0
fi
if [[ "$SELECTED" == "$_text_terminal" ]]; then
    kitty $HOME
    exit 0
fi
if [[ "$SELECTED" == "$_text_dotfiles" ]]; then
    code $HOME/dotfiles
    exit 0
fi
if [[ "$SELECTED" == "$_text_logout_menu" ]]; then
    wlogout
    exit 0
fi
if [[ "$SELECTED" == "$_text_more" ]]; then
    ./rofi-launcher-submenu_settings.sh
    exit 0
fi
fi
