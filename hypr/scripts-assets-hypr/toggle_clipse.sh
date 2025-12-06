#!/bin/bash
if pgrep -x clipse > /dev/null; then
    killall clipse
else
    kitty --class clipse -e clipse &
fi