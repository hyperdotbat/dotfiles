#!/bin/bash
cd "$(dirname "$0")" || exit 1

WALLPAPER_SET_SCRIPT="./wallpaper_set_save.sh"

WALLPAPERS_DIR_OG="~/Pictures/Wallpapers"
# Picker is the only one that should always work from "all" directory
wallpapers_dir_file=".wallpapers_dir"
if [ -f "$wallpapers_dir_file" ]; then
    WALLPAPERS_DIR_OG=$(<$wallpapers_dir_file)
else
    echo "$WALLPAPERS_DIR_OG" > "$wallpapers_dir_file"
fi

WALLPAPERS_DIR="${WALLPAPERS_DIR_OG/#\~/$HOME}"
WALLPAPERS_DIR="${WALLPAPERS_DIR%/}"

if [ ! -d "$WALLPAPERS_DIR" ]; then
    echo "$WALLPAPERS_DIR" does not exist.
    exit 1
else
    # extractable shared piece of code with `start-wallpaper-slideshow.sh`
    WALLPAPER_TOOL="hyprpaper"
    wallpaper_tool_file=".wallpaper_set_tool"
    if [ -f "$wallpaper_tool_file" ]; then
        WALLPAPER_TOOL=$(<$wallpaper_tool_file)
    else
        echo "$WALLPAPER_TOOL" > "$wallpaper_tool_file"
    fi
    if [ "$WALLPAPER_TOOL" == "swww" ]; then
        mapfile -t WALLPAPERS < <(find -L "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | sed "s|$WALLPAPERS_DIR/||" | sort)
    else
        mapfile -t WALLPAPERS < <(find -L "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sed "s|$WALLPAPERS_DIR/||" | sort)
    fi

    if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
        echo "No wallpapers found in $WALLPAPERS_DIR"
        exit 1
    fi

    # set rofi override
    r_override=""
    wallpaper_picker_rofi_override=".wallpaper_picker_rofi_override.rasi"
    if [ -f "$wallpaper_picker_rofi_override" ]; then
        r_override=$(<$wallpaper_picker_rofi_override)
    fi


    entries=""
    for file in "${WALLPAPERS[@]}"; do
        file_path=$WALLPAPERS_DIR/$file
        entries+="$file\x00icon\x1f$file_path\n"
    done

    SELECTED=$(echo -e "Random\n$entries" | rofi -dmenu -theme-str "$r_override" -markup-rows -p "Pick a wallpaper")
    # Simple text based selection
    # SELECTED=$((printf 'Random\n'; printf '%s\n' "${WALLPAPERS[@]}") | rofi -dmenu -p "Pick a wallpaper")
    # Simple text based selection with icons
    # SELECTED=$(echo -e "Random\n$entries" | rofi -dmenu -markup-rows -p "Pick a wallpaper")

    if [[ "$SELECTED" == "Random" ]]; then
        SELECTED="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    fi

    if [[ -n "$SELECTED" ]]; then
        # Overwrite current wallpapers directory path
        echo "${WALLPAPERS_DIR/#\/$HOME/~}" > ".wallpapers_dir_cache"

        WALLPAPER="$WALLPAPERS_DIR/$SELECTED"
        echo "$WALLPAPER"
        "$WALLPAPER_SET_SCRIPT" "$WALLPAPER"
    else
        echo "No wallpaper selected."
    fi
fi
