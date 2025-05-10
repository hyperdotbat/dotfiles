#!/bin/bash
cd "$(dirname "$0")" || exit 1

FREEZE=true
SAVE_SCREENSHOTS=true
SAVE_SCREENSHOTS_IN_MONTH_DIR=true
PLAY_SOUND=true
PLAY_SOUND_VOLUME=0.2

if [ -z "$1" ]; then
    echo "Provide type, possible are: 'active' 'area' 'output' 'screen'"
    exit 1
fi

TYPE=$1

freeze_param=""
if [ "$FREEZE" = true ]; then
    freeze_param="--freeze"
fi

play_sound(){
    if [ "$PLAY_SOUND" = true ]; then
        play screenshot.wav vol $PLAY_SOUND_VOLUME
    fi
}

if [ "$SAVE_SCREENSHOTS" = true ]; then
    SCREENSHOTS_DIR_OG="~/Pictures/Screenshots"
    screenshots_dir_file=".screenshots_dir"
    if [ -f "$screenshots_dir_file" ]; then
        SCREENSHOTS_DIR_OG=$(<$screenshots_dir_file)
    else
        echo "$SCREENSHOTS_DIR_OG" > "$screenshots_dir_file"
    fi
    SCREENSHOTS_DIR="${SCREENSHOTS_DIR_OG%/}"
    SCREENSHOTS_DIR="${SCREENSHOTS_DIR/#\~/$HOME}"
    mkdir -p "$SCREENSHOTS_DIR"

    SCREENSHOT_NAME="$(date '+%Y-%m-%d_%H-%M-%S').png"
    #SCREENSHOT_NAME="Screenshot From $(date '+%Y-%m-%d %H-%M-%S').png" # GNOME format
    screenshot_name_template_file=".screenshot_name_template"
    if [ -f "$screenshot_name_template_file" ]; then
        SCREENSHOT_NAME=$(eval "echo \"$(<"$screenshot_name_template_file")\"")
    else
        echo "\$(date '+%Y-%m-%d_%H-%M-%S').png" > "$screenshot_name_template_file"
    fi
    echo "$SCREENSHOT_NAME"

    FINAL_PATH="$SCREENSHOTS_DIR/$SCREENSHOT_NAME"
    if [ "$SAVE_SCREENSHOTS_IN_MONTH_DIR" = true ]; then
        MONTH_DIR="$(date '+%Y-%m')"
        mkdir -p "$SCREENSHOTS_DIR/$MONTH_DIR"
        FINAL_PATH="$SCREENSHOTS_DIR/$MONTH_DIR/$SCREENSHOT_NAME"
    fi

    grimblast "$freeze_param" copysave "$TYPE" "$FINAL_PATH" && play_sound
else
    grimblast "$freeze_param" copy "$TYPE" && play_sound
fi
