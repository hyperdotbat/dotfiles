#!/bin/bash
# playerctl seems to always favor the browser instead of the last played source
# this is supposed to fix it
# WIP doesnt seem to work

statefile="$HOME/.cache/playerctl-last"

# Restore last used player if stored
if [ -f "$statefile" ]; then
    last_player=$(cat "$statefile")
else
    last_player=""
fi

# Check if the stored player is still running
if [ -n "$last_player" ] && playerctl -p "$last_player" status &>/dev/null; then
    player="$last_player"
else
    # If not, pick the most recently *Playing* one
    player=$(for p in $(playerctl -l); do
        status=$(playerctl -p "$p" status 2>/dev/null)
        if [ "$status" = "Playing" ]; then
            echo "$p"
        fi
    done | tail -n1)

    # If still nothing, fallback to %any
    [ -z "$player" ] && player="%any"
fi

playerctl -p "$player" play-pause

echo "$player" > "$statefile"
