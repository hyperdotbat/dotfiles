#!/bin/bash
cd "$(dirname "$0")" || exit 1

SLIDESHOW_ENABLED=true
SLIDESHOW_FREQUENCY=60
SLEEP_TIME_SEC=60
# ignores if time condition was already met at the beginning, for eg. turned off at night?; dont refresh immediately in the morning
IGNORE_FIRST_RUN=false
FORCE_REFRESH_ON_START=false

FIRST_RUN_PASSED=false

if [ "$SLIDESHOW_ENABLED" = true ]; then
    while true; do
        CURRENT_DATE=$(date +%s)
        LAST_SLIDESHOW_RUN_TIME=$CURRENT_DATE

        wallpapers_slideshow_timer_file=".wallpapers_slideshow_timer_cache"
        if [ -f "$wallpapers_slideshow_timer_file" ]; then
            LAST_SLIDESHOW_RUN_TIME=$(<$wallpapers_slideshow_timer_file)
        fi

        TIME_DIFF=$((CURRENT_DATE - LAST_SLIDESHOW_RUN_TIME))
        echo $((SLIDESHOW_FREQUENCY - (TIME_DIFF / 60)))

        if [ -n "$1" ]; then
            if [ "$1" = "--dry-run" ]; then
                exit 1
            fi
            if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
                TIME_DIFF=(60*SLIDESHOW_FREQUENCY)
            fi
        fi
        
        if (( TIME_DIFF >= 60 * SLIDESHOW_FREQUENCY )) || { [[ "$FORCE_REFRESH_ON_START" = true && "$FIRST_RUN_PASSED" = false ]]; }; then
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
                if [[ "$IGNORE_FIRST_RUN" = false || "$FIRST_RUN_PASSED" = true ]] || [ "$FORCE_REFRESH_ON_START" = true ]; then
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
                        echo "${WALLPAPERS_DIR/#\/$HOME/~}" > ".wallpapers_dir_cache"

                        WALLPAPER="$WALLPAPERS_DIR/$SELECTED"
                        "$WALLPAPER_SET_SCRIPT" "$WALLPAPER"
                    else
                        echo "No wallpaper selected."
                    fi
                fi
                
                echo "$CURRENT_DATE" > "$wallpapers_slideshow_timer_file"
            fi
        fi
        if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
            exit 0
        fi
        sleep $SLEEP_TIME_SEC
        FIRST_RUN_PASSED=true
    done
fi
