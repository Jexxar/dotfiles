#!/bin/bash


#stringZ=abcABC123ABCabc
#echo $stringZ
#
#echo ${#stringZ}                 
#echo `expr length $stringZ`      
#echo `expr "$stringZ" : '.*'`  
#
#
#echo $stringZ
#echo "12345678901234567890"
##       |------|
##       12345678
#
#echo `expr match "$stringZ" 'abc[A-Z]*.2'`   # 8
#echo `expr "$stringZ" : 'abc[A-Z]*.2'`       # 8
#
#stringA="Aline Barros - Extraordinário Amor de Deus - 5. Não Me Calarei"
#echo $stringA
#echo "12345678901234567890"
#tmpa=${stringA#*-}
#tmpb=${stringA%-*}
#echo $tmpa
#echo $tmpb
#mus=${tmpa#*-}
#alb=${tmpa%-*}
##tmpf=${tmpb#*-}
#art=${tmpb%-*}
#echo $mus
#echo $alb
#echo $art
##echo $tmpf
#
##!/bin/bash
## paragraph-space.sh
## Ver. 2.1, Reldate 29Jul12 [fixup]
#
## Inserts a blank line between paragraphs of a single-spaced text file.
## Usage: $0 <FILENAME
#
#MINLEN=60        # Change this value? It's a judgment call.
##  Assume lines shorter than $MINLEN characters ending in a period
##+ terminate a paragraph. See exercises below.
#
#while read line  # For as many lines as the input file has ...
#do
#  echo "$line"   # Output the line itself.
#
#  len=${#line}
#  if [[ "$len" -lt "$MINLEN" && "$line" =~ [*{\.}]$ ]]
## if [[ "$len" -lt "$MINLEN" && "$line" =~ \[*\.\] ]]
## An update to Bash broke the previous version of this script. Ouch!
## Thank you, Halim Srama, for pointing this out and suggesting a fix.
#    then echo    #  Add a blank line immediately
#  fi             #+ after a short line terminated by a period.
#done
#
#exit

# http://api.openweathermap.org/data/2.5/weather?id=6322752&appid=547bbdc38bd641bef6645cd2c4bc613f&units=metric


# check if an application is present and can be executed
function DC_isPresentAndExec() {
    [ -z "$1" ] && return 1;
    local tmp=$(which $1)
    [ -z "$tmp" ] && return 1;

    if [ -x "${tmp}" ]; then 
        return 0; 
    else 
        return 1; 
    fi
}
function _fname_str() {
    local FILE="example.tar.gz"
    if [ ! -z "$1" ]; then
        FILE=$1
    fi
    local f2="${FILE##*/}"

    echo "1) ${FILE}"
    echo "2) ${FILE%%.*}"
    echo "3) ${FILE%.*}"
    echo "4) ${FILE##*/}"
    echo "5) ${FILE#*.}"
    echo "6) ${f2%.*}"
    echo "7) ${FILE##*.}"
}

_fname_str $1

echo " "
echo " "

# YOU SHOULD NOT NEED TO MODIFY ANYTHING BELOW THIS LINE
if DC_isPresentAndExec "xautolock"; then 
	echo "xautolock present=1"; 
else 
	echo "xautolock present=0"; 
fi

DC_xautolockPresent=$(if DC_isPresentAndExec "xautolock"; then echo 1; else echo 0; fi)
DC_gsettingsPresent=$(if DC_isPresentAndExec "gsettings"; then echo 1; else echo 0; fi)
DC_xdgScrSvrPresent=$(if DC_isPresentAndExec "xdg-screensaver"; then echo 1; else echo 0; fi)
DC_mateScrSvrPresent=$(if DC_isPresentAndExec "mate-screensaver"; then echo 1; else echo 0; fi)
DC_gnomeScrSvrPresent=$(if DC_isPresentAndExec "gnome-screensaver"; then echo 1; else echo 0; fi)
DC_cinnamonScrSvrPresent=$(if DC_isPresentAndExec "cinnamon-screensaver"; then echo 1; else echo 0; fi)
DC_xScrSvrPresent=$(if DC_isPresentAndExec "xscreensaver"; then echo 1; else echo 0; fi)

echo "DC_xautolockPresent.....: $DC_xautolockPresent"
echo "DC_gsettingsPresent.....: $DC_gsettingsPresent"
echo "DC_xdgScrSvrPresent.....: $DC_xdgScrSvrPresent"
echo "DC_mateScrSvrPresent....: $DC_mateScrSvrPresent"
echo "DC_gnomeScrSvrPresent...: $DC_gnomeScrSvrPresent"
echo "DC_cinnamonScrSvrPresent: $DC_cinnamonScrSvrPresent"
echo "DC_xScrSvrPresent.......: $DC_xScrSvrPresent"
