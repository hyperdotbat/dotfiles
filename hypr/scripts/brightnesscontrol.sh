#!/usr/bin/env sh

cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF


case $1 in
  i) brightnessctl set +5% ;;
  d) brightnessctl set 5%- ;;
  *) print_error ;;
esac

current_brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
current_percentage=$((current_brightness * 100 / max_brightness))

dunstify "t2" -a "$current_percentage" "Brightness" -r 91191 -t 800
