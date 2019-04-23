#!/usr/bin/env bash

# How to detect whether input is from keyboard, a file, or another process.
# Useful for writing a script that can read from standard input, or prompt the
# user for input if there is none.

# Source: http://www.linuxquestions.org/questions/linux-software-2/bash-scripting-pipe-input-to-script-vs.-1-570945/

if readlink /proc/$$/fd/0 | grep -q "^pipe:"; then
    cat /dev/stdin | sed -e "s/\b\(.\)/\u\1/g"
elif file $( readlink /proc/$$/fd/0 ) | grep -q "character special"; then
    if [ $# -gt 0 ]; then
        echo "$@" | sed -e "s/\b\(.\)/\u\1/g"
#    else
#        echo ""
    fi
else
    if test -s /dev/stdin; then
        cat /dev/stdin | sed -e "s/\b\(.\)/\u\1/g"
    fi
fi
