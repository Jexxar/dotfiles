#!/bin/bash

function askx(){
    return `zenity --forms --modal --text="Entre a posicao X" --title="Entre com X"  ---add-entry="X:"`
}

function asky(){
    return `zenity --forms --modal --text="Entre a posicao Y" --title="Entre com Y"  ---add-entry="Y:"`
}

function mouse2pos(){
    eval $(xdotool getmouselocation --shell)
    local xloc
    local yloc
    if [[ -z "$1" ]]; then
        xloc=$(askx)
    else
        xloc=$1
    fi
    if [[ -z "$2" ]]; then
        yloc=$(asky)
    else
        yloc=$2
    fi
    if [[ -z "$xloc" ]]; then
        xloc=$X
    fi
    if [[ -z "$yloc" ]]; then
        yloc=$Y
    fi

    xdotool mousemove $xloc $yloc click 1;
}

function mouse2pos(){
    local xloc
    local yloc
    if [[ -z "$1" ]]; then
        xloc=askx
    else
        xloc=$1
    fi
    if [[ -z "$2" ]]; then
        yloc=asky
    else
        yloc=$2
    fi
    xdotool mousemove $xloc $yloc click 1;
}

while [ 1 ]; do
    mouse2pos 
    sleep 5
done
