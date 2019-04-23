#!/usr/bin/env bash

if [ -f "$HOME/bin/mylog" ]; then
    . "$HOME/bin/mylog"
fi

scriptName="${0##*/}"
sctiptBase="${scriptName%%.*}"
scriptPath="$(dirname $(readlink -f $0))"

function is_running_X(){
    if ! xset q &>/dev/null; then
        return 1
    fi
    return 0
}

function main(){
    # Only works if X is running.
    if is_running_X; then
        notify-send -t 9000 -i /usr/share/icons/gnome/32x32/status/info.png "$sctiptBase" "`shuf -n1 $scriptPath/.yo-mama-jokes.txt`"
    else
        log "X server is not running";
        shuf -n1 $scriptPath/.yo-mama-jokes.txt
        return 0;
    fi
}

main


