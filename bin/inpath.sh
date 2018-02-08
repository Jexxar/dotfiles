#!/bin/bash
# inpath - verify that a specified program is either valid as-is,
#   or can be found in the PATH directory list.
function in_path() {
    # given a command and the PATH, try to find the command. Returns
    # 0 if found and executable, 1 if not. Note that this temporarily modifies 
    # the the IFS (input field seperator), but restores it upon completion.

    local cmd=$1
    local path=$2
    local retval=1
    local oldIFS=$IFS   
    IFS=":"
    
    for directory in $path
    do
        if [ -x $directory/$cmd ] ; then
            retval=0      # if we're here, we found $cmd in $directory
        fi
    done
    IFS=$oldIFS
    return $retval
}

function checkForCmdInPath() {
    local var=$1
    
    # The variable slicing notation in the following conditional 
    # needs some explanation: ${var#expr} returns everything after
    # the match for 'expr' in the variable value (if any), and
    # ${var%expr} returns everything that doesn't match (in this
    # case just the very first character. You can also do this in
    # Bash with ${var:0:1} and you could use cut too: cut -c1

    if [ "$var" != "" ] ; then
        if [ "${var%${var#?}}" = "/" ] ; then
            if [ ! -x $var ] ; then
                return 1
            fi
        elif ! in_path $var $PATH ; then
            return 2
        fi 
    fi
}

if [ $# -ne 1 ] ; then
    echo "Usage: $0 command" >&2 ; exit 1
fi

checkForCmdInPath "$1"
case $? in
    0 ) echo "$1 found in PATH"           ;;
    1 ) echo "$1 not found or not executable" ;;
    2 ) echo "$1 not found in PATH"       ;;
esac

exit 0