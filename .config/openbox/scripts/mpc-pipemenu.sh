#!/usr/bin/env bash

COMMON_FUNCTIONS="$HOME/.config/openbox/scripts/pipe-common.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    . "${COMMON_FUNCTIONS}" 2> /dev/null
else
    echo $"Error: Failed to locate $COMMON_FUNCTIONS" >&2
    exit 1
fi

# MPD/MPC by olshrimpeyes
hasMPC=$(which mpc)
if [ ! -z "$hasMPC" ]; then
    nowplaying=$(mpc | grep - | sed -e 's/\&/&amp;/g')
    mpcStatus=$(mpc | grep playing)
else
    nowplaying=""
    mpcStatus=""
fi

menuBegin
menuItem "Music Player" "$TERM -e ncmpcpp"
menuSep
if [ -z "$nowplaying" ]; then
    menuItem "Not Playing" "mpc" "preferences-desktop-sound"
else
    menuItem "$nowplaying"
    if [ -z "$mpcStatus" ]; then
        menuItem "Paused" "mpc" "media-playback-pause"
    else
        menuItem "$mpcStatus" "mpc" "preferences-desktop-sound"
    fi
    menuSep
    if [ -z "$mpcStatus" ]; then
        menuItem "Play" "mpc play" "media-playback-start"
    else
        menuItem "Pause" "mpc pause" "media-playback-pause"
        menuItem "Stop" "mpc stop" "media-playback-stop"
    fi
    menuItem "Next" "mpc next" "media-skip-forward"
    menuItem "Previous" "mpc prev" "media-skip-backward"
    menuItem "Volume" "$TERM -e alsamixer" "gnome-volume-control"
fi
menuEnd