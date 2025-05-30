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
        wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read INSULT; do 
            notify-send -t $((3000+300*`echo -n $INSULT | wc -w`)) --urgency="normal" --app-name="$sctiptBase" --icon="$(iconPath info)" "          INSULT" "$INSULT"; 
            #echo $INSULT | espeak; 
        done
    else
        log "X server is not running";
        wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read INSULT; do 
            echo "$INSULT"; 
            #echo $INSULT | espeak; 
        done
        return 0;
    fi
}

main
