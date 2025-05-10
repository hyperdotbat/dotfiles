#!/bin/bash
cd "$(dirname "$0")" || exit 1

options=(
    "App Launcher"
    "Wallpaper Picker"
    "Terminal"
    "Hyprsunset"
    "Toggle darkmode"
    "Configure dotfiles"
    "Logout Menu"
    "More options..."
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
if [[ "$SELECTED" == "App Launcher" ]]; then
    ./launch-rofi.sh
    exit 0
fi
if [[ "$SELECTED" == "Wallpaper Picker" ]]; then
    ./wallpaper_picker.sh
    exit 0
fi
if [[ "$SELECTED" == "Hyprsunset" ]]; then
    ./hyprsunset-toggle.sh
    exit 0
fi
if [[ "$SELECTED" == "Toggle darkmode" ]]; then
    ./toggle-darkmode.sh
    exit 0
fi
if [[ "$SELECTED" == "Terminal" ]]; then
    kitty $HOME
    exit 0
fi
if [[ "$SELECTED" == "Configure dotfiles" ]]; then
    code $HOME/dotfiles
    exit 0
fi
if [[ "$SELECTED" == "Logout Menu" ]]; then
    wlogout
    exit 0
fi
if [[ "$SELECTED" == "More options..." ]]; then
    ./rofi-launcher-submenu_settings.sh
    exit 0
fi
fi
