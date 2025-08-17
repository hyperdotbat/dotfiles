# ~~this requires `rofi/rofi-process-killer.sh` to either be symlinked or moved to `.local/bin` or whatever is on $PATH~~
# this requires dotfiles to be under `~` (i mean where else would u have them lol)
rofi -modi "processes:~/dotfiles/rofi/rofi-process-killer.sh" -show processes -theme-str 'element-text {wrap: true;} window {width: 95%;}'