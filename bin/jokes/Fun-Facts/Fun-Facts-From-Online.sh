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
        wget http://www.randomfunfacts.com -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read TRIVIA; do notify-send -t $((6000+300*`echo -n $TRIVIA | wc -w`)) -i /usr/share/icons/gnome/32x32/status/info.png "          TRIVIA" "$TRIVIA"; done
    else
        log "X server is not running";
        wget http://www.randomfunfacts.com -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;" | while read TRIVIA; do echo "$TRIVIA"; done
        return 0;
    fi
}

main
