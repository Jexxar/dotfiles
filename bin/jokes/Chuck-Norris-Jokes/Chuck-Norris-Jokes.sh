#!/usr/bin/env bash

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

scriptName="${0##*/}"
sctiptBase="${scriptName%%.*}"
scriptPath="$(dirname $(readlink -f $0))"

function main(){
    # Only works if X is running.
    if is_running_X; then
        notify-send -t 11000 --urgency="normal" --app-name="$sctiptBase" --icon="$(iconPath info)" "$sctiptBase" "`shuf -n1 $scriptPath/.chuck-norris-jokes.txt`"
    else
        log "X server is not running";
        shuf -n1 $scriptPath/.chuck-norris-jokes.txt
        return 0;
    fi
}

main
