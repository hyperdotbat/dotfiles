#!/bin/bash
ln -s "$(pwd)/.aliases.sh" "$HOME/"
ln -s "$(pwd)/.aliases-arch.sh" "$HOME/"
ln -s "$(pwd)/.bashprompt.sh" "$HOME/"
ln -s "$(pwd)/.vimrc" "$HOME/"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

ln -s "$(pwd)/hypr" "$CONFIG_DIR/"
ln -s "$(pwd)/waybar" "$CONFIG_DIR/"
ln -s "$(pwd)/fastfetch" "$CONFIG_DIR/"
ln -s "$(pwd)/rofi" "$CONFIG_DIR/"
ln -s "$(pwd)/kitty" "$CONFIG_DIR/"
ln -s "$(pwd)/nvim" "$CONFIG_DIR/"
ln -s "$(pwd)/wlogout" "$CONFIG_DIR/"

