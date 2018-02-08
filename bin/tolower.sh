#!/bin/bash
if readlink /proc/$$/fd/0 | grep -q "^pipe:"; then
    cat /dev/stdin | tr '[:upper:]' '[:lower:]'
elif file $( readlink /proc/$$/fd/0 ) | grep -q "character special"; then
    if [ $# -gt 0 ]; then
        echo "$@" | tr '[:upper:]' '[:lower:]'
 #   else
 #       echo ""
    fi
else
    if test -s /dev/stdin; then
        cat /dev/stdin | tr '[:upper:]' '[:lower:]'
    fi
fi
