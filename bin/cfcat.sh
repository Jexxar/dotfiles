#!/usr/bin/env bash
##########################################################################
# Title      :  cfcat - print contents of configuration files
# Author     :  Heiner Steven <heiner.steven@odn.de>
# Date       :  1993-11-27
# Requires   :  -
# Category   :  System Administration
# SCCS-Id.   :  @(#) cfcat  1.2 04/02/18
##########################################################################
# Description
#     - Prints the given files to standard output. Comments and empty
#   lines are removed, and with "\" continued lines are concatenated
#     - Comments start with a "#" character, and extend to the end of
#   the line. Use a leading "\" for a literal "#" character.
# See also
#   cfget
##########################################################################

PN=`basename "$0"`          # Program name
VER='1.2'

function hhelp {
    echo "$1 - print contents of configuration files, $2"
    echo "usage: cfcat [file  ...]"
    echo
    echo "Comments and empty lines are removed."
    echo "  - Label \"loop\" concatenates with \"\\\" continued lines"
    echo "  - Comments are removed"
    echo "  - Empty lines are removed"
}

if [ $# -eq 0 ] || [ "$1" = "-h" ]; then 
    hhelp $PN $VER
    exit 1
fi

 awk '{ print $0 }' "$@" | sed -n -e '
    :loop
    /\\$/{
    h; n; H; x
    s/\\\n//
    b loop
    }

    /\\#/{
    s/\\#/#/g
    b skip
    }

    /^[     ]*#/d
    /[  ][  ]*#/{
    s/^\(.*\)#.*$/\1/
    }

    :skip
    s/[     ]*$//
    /^$/d

    p
'