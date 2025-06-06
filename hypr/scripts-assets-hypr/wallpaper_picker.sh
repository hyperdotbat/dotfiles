#!/bin/bash
cd "$(dirname "$0")" || exit 1

SEARCH_RECURSIVELY=true
IGNORE_HIDDEN=true
SHOW_RANDOM_SELECTION=false
FILTEROUT_ANIMATED_FOR_OTHER_THAN_SWWW=false # not really needed as for eg. hyprpaper should just set the first frame of .gif or .webp as static

USE_THEME_OVERRIDE=true
USE_ICONS_EVEN_IN_SIMPLE_MODE=true

WALLPAPER_SET_SCRIPT="./wallpaper_set_save.sh"

WALLPAPERS_DIR_OG="~/Pictures/Wallpapers"
# Picker is the only one that should always work from "all" directory
wallpapers_dir_file=".wallpapers_dir"
if [ -f "$wallpapers_dir_file" ] && grep -q '[^[:space:]]' "$wallpapers_dir_file"; then
    WALLPAPERS_DIR_OG=$(<$wallpapers_dir_file)
else
    echo "$WALLPAPERS_DIR_OG" > "$wallpapers_dir_file"
fi

for arg in "$1" "$2"; do
    if [[ "$arg" == "-n" || "$arg" == "--non-recursive" ]]; then
        SEARCH_RECURSIVELY=false
    elif [[ "$arg" == "-r" || "$arg" == "--recursive" ]]; then
        SEARCH_RECURSIVELY=true
    elif [[ "$arg" != "" && "$arg" != -* ]]; then
        WALLPAPERS_DIR_OG="$arg"
    fi
done

WALLPAPERS_DIR="${WALLPAPERS_DIR_OG/#\~/$HOME}"
WALLPAPERS_DIR="${WALLPAPERS_DIR%/}"

if [ ! -d "$WALLPAPERS_DIR" ]; then
    echo "$WALLPAPERS_DIR" does not exist.
    exit 1
else
    depth_param=""
    if [ "$SEARCH_RECURSIVELY" = false ]; then
        depth_param="-maxdepth 1"
    fi

    # extractable shared piece of code with `start-wallpaper-slideshow.sh`
    WALLPAPER_TOOL="hyprpaper"
    wallpaper_tool_file=".wallpaper_set_tool"
    if [ -f "$wallpaper_tool_file" ] && grep -q '[^[:space:]]' "$wallpaper_tool_file"; then
        WALLPAPER_TOOL=$(<$wallpaper_tool_file)
    else
        echo "$WALLPAPER_TOOL" > "$wallpaper_tool_file"
    fi
    if [ "$WALLPAPER_TOOL" == "swww" ] || [ "$FILTEROUT_ANIMATED_FOR_OTHER_THAN_SWWW" = false ]; then
        mapfile -t WALLPAPERS < <(
            find -L "$WALLPAPERS_DIR" $depth_param -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) |
            sed "s|$WALLPAPERS_DIR/||" |
            sort
        )
    else
        filter_animated_webps() {
            while read -r wp; do
                ext="${wp##*.}"
                if [[ "$ext" =~ ^[Ww][Ee][Bb][Pp]$ ]]; then
                    if webpmux -info "$WALLPAPERS_DIR/$wp" 2>/dev/null | grep -q "animation"; then
                        continue
                    fi
                fi
                echo "$wp"
            done
        }

        mapfile -t WALLPAPERS < <(
            find -L "$WALLPAPERS_DIR" $depth_param -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
            sed "s|$WALLPAPERS_DIR/||" |
            sort |
            filter_animated_webps
        )
    fi

    if [ "$IGNORE_HIDDEN" = true ]; then
        mapfile -t WALLPAPERS < <(
            printf '%s\n' "${WALLPAPERS[@]}" | grep -v '^\.'
        )
    fi

    if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
        echo "No valid wallpapers found in $WALLPAPERS_DIR"
        exit 1
    fi

    # set rofi override
    r_override=""
    wallpaper_picker_rofi_override_file=".wallpaper_picker_rofi_override.rasi"
    if [ -f "$wallpaper_picker_rofi_override_file" ]; then
        r_override=$(<$wallpaper_picker_rofi_override_file)
    fi

    # change icon size based on aspect ratio
    x_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
    y_monres=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
    transform=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .transform')
    if [[ "$transform" == "1" || "$transform" == "3" ]]; then
        tmp=$x_monres
        x_monres=$y_monres
        y_monres=$tmp
    fi
    aspect_r=$((x_monres * 10 / y_monres))
    if (( aspect_r > 15 )); then
        ICON_SIZE=40
    elif (( aspect_r < 8 )); then
        # portrait
        ICON_SIZE=20
    else
        ICON_SIZE=30
    fi
    r_override+="element-icon { size: ${ICON_SIZE}% ; }"

    entries=""
    for i in "${!WALLPAPERS[@]}"; do
        file="${WALLPAPERS[$i]}"
        file_path=$WALLPAPERS_DIR/$file
        entries+="$file\x00icon\x1f$file_path"
        if [[ $i -lt $((${#WALLPAPERS[@]} - 1)) ]]; then
            entries+=$'\n'
        fi
    done

    RANDOM_SELECTION_TEXT="Random"
    RANDOM_SELECTED="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    if [ "$SHOW_RANDOM_SELECTION" = true ]; then
        RANDOM_SELECTION_TEXT="Random\x00icon\x1f$WALLPAPERS_DIR/$RANDOM_SELECTED"
    fi
    
    theme_override_flag=()
    if [ "$USE_THEME_OVERRIDE" = true ]; then
        theme_override_flag=(-theme-str "$r_override")
    fi
    if [ "$USE_THEME_OVERRIDE" = false ] && [ "$USE_ICONS_EVEN_IN_SIMPLE_MODE" = false ]; then
        SELECTED=$((printf 'Random\n'; printf '%s\n' "${WALLPAPERS[@]}") | rofi -dmenu -p "Pick a wallpaper ")
    else
        SELECTED=$(echo -e "$RANDOM_SELECTION_TEXT\n$entries" | rofi -dmenu "${theme_override_flag[@]}" -markup-rows -i -p "Pick a wallpaper " -me-select-entry '' -me-accept-entry 'MousePrimary')
    fi

    if [[ "$SELECTED" == "Random" ]]; then
        SELECTED=$RANDOM_SELECTED
    fi

    if [[ -n "$SELECTED" ]]; then
        # Overwrite current wallpapers directory path
        echo "${WALLPAPERS_DIR/#\/$HOME/~}" > ".wallpapers_dir_cache"
        echo "Set ${WALLPAPERS_DIR/#\/$HOME/~} as current wallpaper_dir_cache"

        WALLPAPER="$WALLPAPERS_DIR/$SELECTED"
        echo "$WALLPAPER"
        "$WALLPAPER_SET_SCRIPT" "$WALLPAPER"
    else
        echo "No wallpaper selected."
        exit 1
    fi
fi
