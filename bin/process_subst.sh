#!/bin/bash
e_header "Process Substituition"

e_note "Without Substituition"

echo "Subshell level OUTSIDE = $BASH_SUBSHELL"
ls /home |  # This part fork a subshell, and send the output to the next command
sort | # here is another subshell (we could say sub-subshell !)
while read line ; do # and finally we get ourselves inside the loop ...
    echo "Subshell level INSIDE = $BASH_SUBSHELL"
    echo "line is : $line"
    ligne=$line
done # let's go back to the first shell now
 
echo "Value of \$line outside the loop : '$line'"
echo "Value of \$ligne outside the loop : '$ligne'"

e_note "With Substituition"

echo "Subshell level OUTSIDE = $BASH_SUBSHELL"
while read line ; do
    echo "Subshell level INSIDE = $BASH_SUBSHELL"
    echo "line is : $line"
    ligne=$line
done < <(ls /home | sort)
 
echo "Value of \$line outside the loop : '$line'"
echo "Value of \$ligne outside the loop : '$ligne'"