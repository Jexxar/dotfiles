#!/bin/bash
if readlink /proc/$$/fd/0 | grep -q "^pipe:"; then
    cat /dev/stdin | tr '[:lower:]' '[:upper:]'
elif file $( readlink /proc/$$/fd/0 ) | grep -q "character special"; then
    if [ $# -gt 0 ]; then
        echo "$@" | tr '[:lower:]' '[:upper:]'
#    else
 #       echo "Usage: $0 <param>" 
    fi
else
    if test -s /dev/stdin; then
        cat /dev/stdin | tr '[:lower:]' '[:upper:]'
    fi
fi
