#!/bin/bash
cd "$(dirname "$0")" || exit 1

SLIDESHOW_ENABLED=true
SEPERATE_DARKMODE_DIR=true
SLIDESHOW_FREQUENCY=60
SLEEP_TIME_SEC=60
# ignores if time condition was already met at the beginning, for eg. turned off at night?; dont refresh immediately in the morning
IGNORE_FIRST_RUN=false
FORCE_REFRESH_ON_START=false
FILTEROUT_ANIMATED_FOR_OTHER_THAN_SWWW=false # not really needed as for eg. hyprpaper should just set the first frame of .gif or .webp as static

WALLPAPER_SET_SCRIPT="./wallpaper_set_save.sh"
isdarkmode_file=".is-darkmode_cache"

FIRST_RUN_PASSED=false
isdarkmode=false


if [ "$SLIDESHOW_ENABLED" = false ]; then
    echo "Slideshow is disabled"
    exit 1
fi
if [ "$SLIDESHOW_ENABLED" = true ]; then
    while true; do
        if [ -f "$isdarkmode_file" ] && grep -q '[^[:space:]]' "$isdarkmode_file"; then
            isdarkmode=true
        fi

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
            if [ "$1" = "--update" ] || [ "$1" = "-u" ]; then
                echo "$CURRENT_DATE" > "$wallpapers_slideshow_timer_file"
                echo $((SLIDESHOW_FREQUENCY - (TIME_DIFF / 60)))
                exit 1
            fi
        fi
        
        if (( TIME_DIFF >= 60 * SLIDESHOW_FREQUENCY )) || { [[ "$FORCE_REFRESH_ON_START" = true && "$FIRST_RUN_PASSED" = false ]]; }; then
            WALLPAPERS_DIR_OG="~/Pictures/Wallpapers-Slideshow"
            wallpapers_dir_file=".wallpapers_dir_slideshow"
            if [ -f "$wallpapers_dir_file" ] && grep -q '[^[:space:]]' "$wallpapers_dir_file"; then
                WALLPAPERS_DIR_OG=$(<$wallpapers_dir_file)
            else
                echo "$WALLPAPERS_DIR_OG" > "$wallpapers_dir_file"
            fi
            if [ "$SEPERATE_DARKMODE_DIR" = true ] && [ "$isdarkmode" = true ]; then
                WALLPAPERS_DARK_DIR_OG="~/Pictures/Wallpapers-Slideshow_dark"
                wallpapers_darkmode_dir_file=".wallpapers_dir_slideshow_dark"
                if [ -f "$wallpapers_darkmode_dir_file" ]; then
                    # override only if not empty
                    if grep -q '[^[:space:]]' "$wallpapers_darkmode_dir_file"; then
                        WALLPAPERS_DIR_OG=$(<$wallpapers_darkmode_dir_file)
                    fi
                else
                    echo "$WALLPAPERS_DARK_DIR_OG" > "$wallpapers_darkmode_dir_file"
                fi
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

                        isdarkmode_wallpaper_file=".is-darkmode-wallpaper_cache"
                        if [ "$isdarkmode" = true ]; then
                            echo 'true' > $isdarkmode_wallpaper_file
                        else
                            echo '' > $isdarkmode_wallpaper_file
                        fi
                    else
                        echo "No wallpaper selected."
                        exit 1
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
