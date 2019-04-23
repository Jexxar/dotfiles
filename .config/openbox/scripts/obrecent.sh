#!/usr/bin/env bash
COMMON_FUNCTIONS="$HOME/.config/openbox/scripts/pipe-common.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    . "${COMMON_FUNCTIONS}" 2> /dev/null
else
    echo $"Error: Failed to locate $COMMON_FUNCTIONS" >&2
    exit 1
fi

function doMenu(){
    local file=""
    local name=""
    menuBegin
    
    cat ~/.local/share/recently-used.xbel | grep file:///  | tail -n15 |  cut -d "\"" -f 2 | tac | while read line; do
        file=$(echo "$line" | sed 'y/+/ /; s/%/\\x/g')
        name=$(echo -en "$file" | sed 's,.*/,,' | sed 's/ //g')
        menuItem $name "xdg-open $line"
    done;
    
    menuItem "$name"
    menuItem "Limpar lista" "rm ~/.local/share/recently-used.xbel"
    
    menuEnd
}

doMenu