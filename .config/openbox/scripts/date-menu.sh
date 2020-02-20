#!/usr/bin/env bash
#
# date-menu.sh
#
# This is in the public domain.  Honestly, how can you claim anything to something
# this simple?
#
# Outputs a simple openbox pipe menu to display the date, time, and calendar.
# You need 'date' and 'cal'.  You should have these.  Additionally, the calendar
# only appears properly formated if you use a mono spaced font.

# Outputs the selected row from the calender output.
# If you don't use a mono spaced font, you would have to play with spacing here.
# It would probably involve a very complicated mess.  Is there a way to force a
# different font per menu?

COMMON_FUNCTIONS="$HOME/.config/openbox/scripts/pipe-common.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    . "${COMMON_FUNCTIONS}" 2> /dev/null
else
    echo $"Error: Failed to locate $COMMON_FUNCTIONS" >&2
    exit 1
fi

function calRow() {
   cal | gawk -v row=$1 '{ if (NR==row) { print $0 } }'
}

menuBegin
menuSep "`date +%A\ \ \ \ \ \ \ \ \ \ \ \ %I\:%M\ %p`"
menuItem "`calRow 2`"
menuItem "`calRow 3`"
menuItem "`calRow 4`"
menuItem "`calRow 5`"
menuItem "`calRow 6`"
menuItem "`calRow 7`"
menuItem "`calRow 8`"
menuEnd
