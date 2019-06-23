#!/usr/bin/env bash
COMMON_FUNCTIONS="$HOME/.config/openbox/scripts/pipe-common.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    . "${COMMON_FUNCTIONS}" 2> /dev/null
else
    echo $"Error: Failed to locate $COMMON_FUNCTIONS" >&2
    exit 1
fi

function doMenu(){
    local f=""
    menuBegin
    
    grep "file:///" ~/.local/share/recently-used.xbel | tail -n15 | cut -d "\"" -f 2 | tac | while read line; do
        f=$(echo "$line" | sed 's,.*/,,' | sed 'y/+/ /; s/%/\\x/g')
        f=$(echo -en "$f")
        menuItem "$f" "xdg-open \"$line\""
    done;
    
    menuSep 
    menuItem "Limpar lista" "rm ~/.local/share/recently-used.xbel"
    menuEnd
}

doMenu

