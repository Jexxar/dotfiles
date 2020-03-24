#!/usr/bin/env bash
set -eu

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

#kill_older  

function t1(){
    local WallDir="${XDG_PICTURES_DIR:-$HOME/Imagens}/Wallpaper"
    local old_IFS=$IFS
    IFS=$'\n'
    local WallList=( `find "$WallDir" -type f -iregex ".*/.*[.]\(jpe?g\|png\|gif\|bmp\)"` )
    IFS=$old_IFS
    echo "${WallList[@]}"
    echo "------"
    echo "${#WallList[@]}"
    echo "------"
    for i in "${WallList[@]}"; do
        echo $i
    done
}


script_name=${BASH_SOURCE[0]}
echo "script_name == $script_name"
for pid in $(pidof -x $script_name); do
    if [ $pid != $$ ]; then
        #kill -9 $pid
        echo "will terminate $pid"
    fi 
done