#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")" || exit 1

OPEN_CURRENT_MONTH_IF_EXISTS=true

SCREENSHOTS_DIR_OG="~/Pictures/Screenshots"
screenshots_dir_file=".screenshots_dir"
if [ -f "$screenshots_dir_file" ]; then
    SCREENSHOTS_DIR_OG=$(<$screenshots_dir_file)
else
    echo "$SCREENSHOTS_DIR_OG" > "$screenshots_dir_file"
fi
SCREENSHOTS_DIR="${SCREENSHOTS_DIR_OG%/}"
SCREENSHOTS_DIR="${SCREENSHOTS_DIR_OG/#\~/$HOME}"

FINAL_PATH="$SCREENSHOTS_DIR"
if [ "${OPEN_CURRENT_MONTH_IF_EXISTS:-0}" = true ]; then
    MONTH_DIR="$(date '+%Y-%m')"
    if [ -d "$SCREENSHOTS_DIR/$MONTH_DIR" ]; then
        FINAL_PATH="$SCREENSHOTS_DIR/$MONTH_DIR"
    fi
fi

echo "$FINAL_PATH"
xdg-open "$FINAL_PATH"