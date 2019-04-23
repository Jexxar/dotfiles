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
        wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read INSULT; do notify-send -t $((3000+300*`echo -n $INSULT | wc -w`)) -i /usr/share/icons/gnome/32x32/status/info.png "          INSULT" "$INSULT"; echo $INSULT | espeak; done
    else
        log "X server is not running";
        wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read INSULT; do echo "$INSULT"; echo $INSULT | espeak; done
        return 0;
    fi
}

main
