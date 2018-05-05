#!/bin/bash
function is_running_X(){
    if ! xset q &>/dev/null; then
        return 1
    fi
    return 0
}

function change_wallpaper(){
	local old_IFS=$IFS
	IFS="
	"
	local WallDir="$HOME/Imagens/Wallpaper"
	local WallList=( `find "$WallDir" -type f -iregex ".*/.*[.]\(jpe?g\|png\|gif\|bmp\)"` )
	IFS=$old_IFS
	local MaxFiles=${#WallList[@]}
	#let "number = $RANDOM"
	#let CurrIndex="`cat $WallDir/.last` + $number"
	local LastFile="$WallDir/.last"
	if [ -f $LastFile ]; then 
	    let CurrIndex="`cat $LastFile` + 1"
	    if [ $CurrIndex -ge $MaxFiles ]; then
	        let CurrIndex=1
	    fi
	else
	    let CurrIndex=1
	fi
	local number
	let number=$CurrIndex
	echo $number > $WallDir/.last
	nitrogen --set-scaled --save "${WallList[$number]}"
}

function main(){
	while [ is_running_X ]; do 
	    if [ -z $DISPLAY ]; then
    	    DISPLAY=:0.0
    	fi
		change_wallpaper;
		sleep 7m;
	done;	
	if [ ! is_running_X ]; then
    	echo "No X server at \$DISPLAY [$DISPLAY]" >&2
    	exit 0
	fi
}

main
