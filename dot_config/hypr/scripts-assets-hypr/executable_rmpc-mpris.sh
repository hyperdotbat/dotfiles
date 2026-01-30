#!/bin/bash
mpc update

# Start RMPC with MPRIS
mpd-mpris -no-instance &
MPID=$!
rmpc
kill -INT $MPID
wait $MPID

# systemctl --user start mpd-mpris.service
# rmpc
# systemctl --user stop mpd-mpris.service

# mpd-mpris -no-instance &
# MPID=$!
# # Make sure mpd-mpris gets killed properly on exit
# trap 'kill -INT $MPID; wait $MPID' EXIT
# # Run RMPC (blocking)
# rmpc