#!/bin/bash
COMMON_FUNCTIONS="$HOME/.config/openbox/scripts/pipe-common.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    . "${COMMON_FUNCTIONS}" 2> /dev/null
else
    echo $"Error: Failed to locate $COMMON_FUNCTIONS" >&2
    exit 1
fi

function doMenu(){
    menuBegin
    
    cat ~/.local/share/recently-used.xbel | grep file:///  | tail -n15 |  cut -d "\"" -f 2 | tac | while read line; do
        file=$(echo "$line")
        name=$(echo -en "$file" | sed 's,.*/,,' | sed 's/%20/ /g')
        menuItem $name "xdg-open $line"
    done;
    
    menuItem $name
    menuItem "Limpar lista" "rm ~/.local/share/recently-used.xbel"
    
    menuEnd
}

doMenu