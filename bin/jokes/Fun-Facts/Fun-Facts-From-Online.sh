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
        wget http://www.randomfunfacts.com -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read TRIVIA; do 
            notify-send -t $((6000+300*`echo -n $TRIVIA | wc -w`)) --urgency="normal" --app-name="$sctiptBase" --icon="$(iconPath info)" "          TRIVIA" "$TRIVIA"; 
        done
    else
        log "X server is not running";
        wget http://www.randomfunfacts.com -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read TRIVIA; do echo "$TRIVIA"; done
        return 0;
    fi
}

main
