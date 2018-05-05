#!/bin/bash

# common functions for pipe menus

# required awk, bc

function awk_round () {
    awk 'BEGIN{printf "%."'$1'"f\n", "'$2'"}'
}

function menuBegin() {
    echo "<openbox_pipe_menu>"
}

function menuEnd() {
    echo "</openbox_pipe_menu>"
}

function menuSep() {
    if [ -z "$1" ]; then 
        echo "<separator />"
    else
        echo "<separator label=\"$1\"/>"
    fi
}

function menuItem() {
    if [ -z "$2" ]; then
        echo "<item label=\"$1\"/>"
    else
        echo "<item label=\"$1\"> <action name=\"Execute\"><command>$2</command></action> </item>"
    fi
}
