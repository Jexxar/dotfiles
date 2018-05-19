#!/bin/bash

# common functions for pipe menus

# required awk, bc

function iconPath(){
    local tmpIconThemeName=$(gsettings get org.mate.interface icon-theme | tr -d "'")
    [ -z "$tmpIconThemeName" ] && tmpIconThemeName=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
    local tmpIconPath="/usr/share/icons/$tmpIconThemeName"
    if [ -d "$tmpIconPath" ]; then
        echo "$tmpIconPath"
        return 0
    else
        tmpIconPath="$HOME/.icons/$tmpIconThemeName"
        if [ -d "$tmpIconPath" ]; then
            echo "$tmpIconPath"
            return 0
        fi
    fi 
    echo ""
    return 1
}

function awkRound () {
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
    if [ ! -z "$3" ]; then
        echo "<item label=\"$1\" icon=\"$3\">  <action name=\"Execute\"><command>$2</command></action> </item>"
    elif [ ! -z "$2" ]; then
        echo "<item label=\"$1\"> <action name=\"Execute\"><command>$2</command></action> </item>"
    else
        echo "<item label=\"$1\"/>"
    fi
}

function subMenuBegin() {
    if [ ! -z "$3" ]; then
        echo "<menu id=\"$1\" icon=\"$3\" label=\"$2\" >"
    elif [ ! -z "$2" ]; then
        echo "<menu id=\"$1\" label=\"$2\">"
    fi
}

function subMenuActionExec() {
    if [ ! -z "$1" ]; then
        echo "<action name=\"Execute\">"
        echo "<execute> $1 </execute>"
        echo "</action>"
    fi
}

function subMenuExec() {
    if [ ! -z "$4" ]; then
        echo "<menu id=\"$1\" icon=\"$4\" label=\"$2\" execute=\"$3\" />"
    elif [ ! -z "$3" ]; then
        echo "<menu id=\"$1\" label=\"$2\" execute=\"$3\" />"
    fi
}

function subMenuEnd() {
    echo "</menu>"
}

