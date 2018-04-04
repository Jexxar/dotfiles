#!/bin/bash
numberArgs=$#
yadOrzen=`which zenity || which yad`

[ -z "$yadOrzen" ] && exit 1

DestToBe=`${yadOrzen} --file-selection --directory --title="Choose your target directory"`

if [ $? -ne 0 ]; then
    ${yadOrzen} --error --text="Operation Aborted"
    exit 1
fi

[ -z "$DestToBe" ] && exit 1

pc=0

TargetDir=`awk -F, '{print $1}' <<<$DestToBe`

old_IFS=$IFS
IFS=$'\n'

if [ -z $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
    NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$*
fi

# Loop through the list (from either Nautilus or the command line)
for FullName in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    ShortName=${FullName##*/}
    if [[ -w $TargetDir && -e $TargetDir/$ShortName ]]; then
        confirm=$(${yadOrzen} --question --title "File already exists" --text "Overwrite File: \n$TargetDir/$ShortName?"; echo $?)
        if [[ $confirm -eq 0 ]]; then
            cp -r "${FullName}" "$TargetDir/"
            if (( $? != 0 )); then
                ${yadOrzen} --info --text "Something went wrong $TargetDir/$ShortName" --title "Failure"
            fi
        fi
    else
        if [[ -w $TargetDir && ! -e $TargetDir/$ShortName ]]; then
            cp -r "${FullName}" "$TargetDir/"
            if (( $? != 0 )); then
                ${yadOrzen} --info --text "Something went wrong $TargetDir/$ShortName" --title "Failure"
            fi
        else
            UsrOwner="$(stat --format '%U' "${TargetDir}")"
            ${yadOrzen} --text-info --text="[$UsrOwner]:$TargetDir is not writable" --title "Failure"
        fi
    fi
done | ${yadOrzen}  --progress --auto-close --title="Copy files to $TargetDir"

if [ $? -eq 1 ]; then
    ${yadOrzen} --error --text="Cancelled!"
    IFS=$old_IFS
    exit 1
fi

IFS=$old_IFS
