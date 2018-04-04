#!/bin/bash
function is_running_X(){
    if ! xset q &>/dev/null; then
        return 1
    fi
    return 0
}

if [ is_running_X ]; then
    if [ -z $DISPLAY ]; then
        DISPLAY=:0.0
    fi
else
    echo "No X server at \$DISPLAY [$DISPLAY]" >&2
    exit 0
fi

old_IFS=$IFS
IFS="
"
WALLPAPERS="$HOME/Imagens/Wallpaper"
#ALIST=( `ls -w1 $WALLPAPERS` )
ALIST=( `find "$WALLPAPERS" -type f -iregex ".*/.*[.]\(jpe?g\|png\|gif\|bmp\)"` )
IFS=$old_IFS
RANGE=${#ALIST[@]}
#let "number = $RANDOM"
#let LASTNUM="`cat $WALLPAPERS/.last` + $number"
last_f="$WALLPAPERS/.last"
if [ -f $last_f ]; then 
    let LASTNUM="`cat $last_f` + 1"
    if [ $LASTNUM -ge $RANGE ]; then
        let LASTNUM=1
    fi
else
    let LASTNUM=1
fi
#let "number = $LASTNUM % $RANGE"
let number=$LASTNUM
echo $number > $WALLPAPERS/.last
#echo "range == $RANGE"
#echo "number == $number"
#echo "wallpaper == ${ALIST[$number]}"
#nitrogen --set-scaled --save "${ALIST[$number]}"
nitrogen --set-zoom-fill --save "${ALIST[$number]}"
