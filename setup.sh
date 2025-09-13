#!/bin/bash
cd "$(dirname "$0")" || exit 1

## TODO: Make prompts and echo message for each bunch of symlinks etc
# Source these 3 in .bashrc
ln -s "$(pwd)/.aliases.sh" "$HOME/"
ln -s "$(pwd)/.aliases-arch.sh" "$HOME/"
ln -s "$(pwd)/.bashprompt.sh" "$HOME/"

ln -s "$(pwd)/.vimrc" "$HOME/"
ln -s "$(pwd)/.tmux.conf" "$HOME/"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$CONFIG_DIR/xdg-desktop-portal/"
ln -s "$(pwd)/xdg-desktop-portal/hyprland-portals.conf" "$CONFIG_DIR/xdg-desktop-portal/"

ln -s "$(pwd)/hypr" "$CONFIG_DIR/"
ln -s "$(pwd)/waybar" "$CONFIG_DIR/"
ln -s "$(pwd)/fastfetch" "$CONFIG_DIR/"
ln -s "$(pwd)/rofi" "$CONFIG_DIR/"
ln -s "$(pwd)/kitty" "$CONFIG_DIR/"
ln -s "$(pwd)/nvim" "$CONFIG_DIR/"
ln -s "$(pwd)/wlogout" "$CONFIG_DIR/"
ln -s "$(pwd)/dunst" "$CONFIG_DIR/"

# Add all "temp/cache files"
touch "$(pwd)/rofi/.import-darkmode_cache.conf"
touch "$(pwd)/waybar/.import-darkmode_cache.conf"
touch "$(pwd)/wlogout/.import-darkmode_cache.conf"

touch "$(pwd)/hypr/.import-darkmode_cache.conf"
touch "$(pwd)/hypr/.import-nogaps_cache.conf"
touch "$(pwd)/hypr/.import-smartgaps_cache.conf"
touch "$(pwd)/hypr/.import-monitors_cache.conf"

# touch "$(pwd)/hypr/scripts-assets-hypr/.is-darkmode_cache"
# touch "$(pwd)/hypr/scripts-assets-hypr/.is-darkmode-wallpaper_cache"
# touch "$(pwd)/hypr/scripts-assets-hypr/.wallpaper_current_path_cache"
# touch "$(pwd)/hypr/scripts-assets-hypr/.wallpaper_current_path_darkmode_cache"
# touch "$(pwd)/hypr/scripts-assets-hypr/.wallpaper_dir_cache"

