#!/bin/bash
cd "$(dirname "$0")" || exit 1

SLIDESHOW_ENABLED=true
SLIDESHOW_FREQUENCY=60
IGNORE_FIRST_RUN=true

FIRST_RUN_PASSED=false

if [ "$SLIDESHOW_ENABLED" = true ]; then
    while true; do
        CURRENT_DATE=$(date +%s)
        if [ "$IGNORE_FIRST_RUN" = false ] || [ "$FIRST_RUN_PASSED" = true ]; then
            WALLPAPER_SET_SCRIPT="./wallpaper_set_save.sh"

            # You can absolutely have a separate slideshow directory
            WALLPAPERS_DIR_OG="~/Pictures/Wallpapers" #"~/Pictures/Wallpapers-Slideshow"
            wallpapers_dir_file=".wallpapers_dir_slideshow"
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
                # extractable shared piece of code with `wallpaper_picker.sh`
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

                # TODO: Improve randomization
                SELECTED="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"

                if [[ -n "$SELECTED" ]]; then
                    # Overwrite current wallpapers directory path
                    echo "${WALLPAPERS_DIR_OG/#\/$HOME/~}" > ".wallpapers_dir"

                    WALLPAPER="$WALLPAPERS_DIR/$SELECTED"
                    "$WALLPAPER_SET_SCRIPT" "$WALLPAPER"
                else
                    echo "No wallpaper selected."
                fi
            fi
        fi
        # Either do sleep for the amount, or check every minute to compare a saved value? (the latter would be useful when configuration comes in and being able to stop the slideshow)
        sleep $((60 * SLIDESHOW_FREQUENCY))
        FIRST_RUN_PASSED=true
    done
fi