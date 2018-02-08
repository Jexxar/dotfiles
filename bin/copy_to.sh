#!/bin/bash
numberArgs=$#
has_yad=`which yad`
if [ -z "$has_yad" ]; then
    OUTPUT=`zenity --file-selection --directory --title="Choose your target directory"`
else
    OUTPUT=`yad --file-selection --center --directory --title="Choose your target directory"`
fi

if [ "$?" -eq 1 ]; then
    zenity --error --text="Operation Aborted"
    exit 1
fi
pc=0

TARGETDIR=`awk -F, '{print $1}' <<<$OUTPUT`

for (( i=1; i<=$numberArgs; i++ )); do
    #echo "# ${1##*/}"
    cp -r "${1}" "$TARGETDIR/"
    let pc=i*100
    #echo $pc
    let pc=$pc/$numberArgs
    #echo $pc
    sleep 0.5
    shift 1
done | zenity --progress --title="Copy files to $TARGETDIR" --percentage=0

if [ "$?" -eq 1 ]; then
    zenity --error --text="Cancelled!"
    exit 1
fi
