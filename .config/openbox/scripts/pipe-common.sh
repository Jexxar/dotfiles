#!/bin/bash

# common functions for pipe menus

# required awk, bc

function findJPG(){
    if [ [ -z "$1" ] || [ -z "$2" ] ]; then
        echo ""
        return 1
    fi
    local iconJPG="${2}.jpg"
    cd ${1} 
    find . -name ${iconJPG} | grep "16" | cut -c 2- | tail -n 1
    return 0
}

function findPNG(){
    if [ [ -z "$1" ] || [ -z "$2" ] ]; then
        echo ""
        return 1
    fi
    local iconPNG="${2}.png"
    cd ${1} 
    find . -name ${iconPNG} | grep "16" | cut -c 2- | tail -n 1
    return 0
}

function findSVG(){
    if [ [ -z "$1" ] || [ -z "$2" ] ]; then
        echo ""
        return 1
    fi
    local iconSVG="${2}.svg"
    cd ${1} 
    find . -name ${iconSVG} | cut -c 2- | tail -n 1
    return 0
}

function iconPath(){
    if [ -z "$1" ]; then
        echo ""
        return 1
    fi
    
    local pathFound="no"
    local tmpIconName=""
    local tmpIconThemeName=$(gsettings get org.mate.interface icon-theme | tr -d "'")
    
    [ -z "$tmpIconThemeName" ] && tmpIconThemeName=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
    
    local tmpIconPath="/usr/share/icons/$tmpIconThemeName"
    
    if [ -d "$tmpIconPath" ]; then
        pathFound="yes"
    else
        tmpIconPath="$HOME/.icons/$tmpIconThemeName"
        if [ -d "$tmpIconPath" ]; then
            pathFound="yes"
        fi
    fi
    
    if [ "$pathFound" = "yes" ]; then
        local tmpIconName=$(findSVG $tmpIconPath ${1})
        [ -z "$tmpIconName" ] && tmpIconName=$(findPNG $tmpIconPath ${1})
        [ -z "$tmpIconName" ] && tmpIconName=$(findJPG $tmpIconPath ${1})
        if [ -z "$tmpIconName" ]; then
            echo ""
            return 1
        fi
        echo "$tmpIconPath/$tmpIconName"
        return 0
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
        local iconName=$(iconPath $3)
        echo "<item label=\"$1\" icon=\"$iconName\">  <action name=\"Execute\"><command>$2</command></action> </item>"
    elif [ ! -z "$2" ]; then
        echo "<item label=\"$1\"> <action name=\"Execute\"><command>$2</command></action> </item>"
    else
        echo "<item label=\"$1\"/>"
    fi
}

function subMenuBegin() {
    if [ ! -z "$3" ]; then
        local iconName=$(iconPath $3)
        echo "<menu id=\"$1\" icon=\"$iconPath\" label=\"$2\" >"
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
        local iconName=$(iconPath $4)
        echo "<menu id=\"$1\" icon=\"$iconName\" label=\"$2\" execute=\"$3\" />"
    elif [ ! -z "$3" ]; then
        echo "<menu id=\"$1\" label=\"$2\" execute=\"$3\" />"
    fi
}

function subMenuEnd() {
    echo "</menu>"
}

