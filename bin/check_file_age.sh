#!/bin/bash
# This checks that the specified file is less than 28 hours old.
# returns 0 if younger than 28 hours.
# returns 1 if older than 28 hours.
 
#funtion arguments -> filename to comapre against curr time
function comparedate() {
    if [ ! -f $1 ]; then
      echo "file $1 does not exist"
        exit 1
    fi
    local MAXAGE=$(bc <<< '28*60*60') # seconds in 28 hours
    # file age in seconds = current_time - file_modification_time.
    local FILEAGE=$(($(date +%s) - $(stat -c '%Y' "$1")))
    test $FILEAGE -lt $MAXAGE && {
        echo "$1 is less than 28 hours old."
        return 0
    }
    echo "$1 is older than 28 hours seconds."
    return 1
}

if [ ! -z "$1" ]; then
    comparedate $1
else
    echo "Usage: `basename $0` [filename]"
fi

