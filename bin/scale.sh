#!/usr/bin/env bash

function usage(){
    echo "Usage: $(basename $0) [Options]"
    echo "       "
    echo "    Custom scale X server resolution"
    echo "           "
    echo "    Options"
    echo "    -h | --help : Show this help"
    echo "    -a | --auto: Auto scaling"
    echo "    -e | --external: External settings"
    echo "    -m | --maximum: Maximum scaling"
    echo "    -l | --lower: Lower scaling"
}

function setLVDS1(){
    case "$1" in
        a)
            xrandr --output LVDS1 --auto
            xrandr --dpi 96
        ;;
        m)
            xrandr --newmode "1366x768_60.00a" 84.75 1366 1438 1574 1782 768 771 781 798 -hsync +vsync
            xrandr --addmode LVDS1 1366x768_60.00a
            xrandr --output LVDS1 --mode 1366x768_60.00a
            xrandr --dpi 96
        ;;
        e)
            extres="1600x1200"
            xrandr --output eDP1 --mode $extres --output HDMI1 --mode $extres --same-as eDP1
            xrandr --dpi 96
        ;;
        l)
            extres="1024x768"
            xrandr --output eDP1 --mode $extres --output DP1 --mode $extres --same-as eDP1
            xrandr --dpi 96
        ;;
    esac
    
}

function setHDMI1(){
    case "$1" in
        a*)
            xrandr --output LVDS1 --auto
            xrandr --dpi 96
        ;;
        h*)
            xrandr --output eDP1 --mode 3200x1800
            xrandr --output HDMI1 --auto
            xrandr --output DP1 --auto
            xrandr --dpi 235
        ;;
        e*)
            extres="1600x1200"
            xrandr --output eDP1 --mode $extres --output HDMI1 --mode $extres --same-as eDP1
            xrandr --dpi 96
        ;;
        d*)
            extres="1024x768"
            xrandr --output eDP1 --mode $extres --output DP1 --mode $extres --same-as eDP1
            xrandr --dpi 96
        ;;
    esac
}

function setDP1(){
    
}

function setVGA1(){
    
}

function setVIRTUAL1(){
    
}

function main(){
    precheck "xrandr"
    
    # Option strings
    SHORT=":a::e::m::h::l"
    LONG=":auto,external,maximum,help,lower"
    
    # Read the options
    OPTS=$(getopt --options $SHORT --long $LONG --name "$0" -- "$@")
    if [ $? -ne 0 ] ; then
        echo "Wrong parameters.OPTS=[$OPTS][ $* ]"
        usage
        exit 0
    fi
    for m in $(xrandr | grep " connected" | awk '{print $1}'); do
        xrandr
    done
    next="$1"
    if [ -z "$1" ]; then
        if xrandr | grep "^HDMI1 connected"; then
            next="external"
        elif xrandr | grep "^DP1 connected"; then
            next="dp1"
        elif xrandr | grep eDP1 | grep 3200x1800; then
            next="low"
        else
            next="high"
        fi
    fi
    
    echo "Scaling to $next"
    
    case "$1" in
        -a | --all )
            exit 0
        ;;
        -s | --select )
            exit 0
        ;;
        -l | --list )
            exit 0
        ;;
        -v | --view )
            exit 0
        ;;
        -g | --suggest )
            exit 0
        ;;
        *)  usage
            exit 0
        ;;
    esac
}

main "$@"

