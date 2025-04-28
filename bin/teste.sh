#!/usr/bin/env bash
#set -eu

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

# path to your "recent files" script, if you want to incorporate it:
recent_script=$HOME/.config/openbox/scripts/recent-pipemenu
# Command to open folders at "Browse here..." - any file manager
#open_folder_cmd=pcmanfm
# Default command to open files with - others might be xdg-open, gnome-open, pcmanfm...
default_open_cmd=xdg-open  # exo-open comes with thunar
# Text editor of choice
text_editor=~/bin/myedit

# File mounter of choice
file_mounter=~/bin/myisomount

# extra dotfiles to display in HOME folder (dotfiles are hidden by default)
# edit the list (space separated, surrounded by single quotes) or comment this line out, to taste:
shown_dotfiles='.config .local .cache .bashrc .bash_profile .bash_history'

runDesktop () {
  comm=( $(awk -F= '$1=="Exec"{$1=""; print}' "$1") )
  "${comm[0]}" "${comm[@]:1}" &
  disown
}

function necho() { for a; do printf '%s\n' "$a"; done; }
function zecho() { for a; do printf '%s\0' "$a"; done; }
function qecho() { for a; do printf '\302\273%s\302\253 ' "$a"; done; printf '\n'; }
function jecho() { printf '%s' "$@"; }
function secho() {
  [ "$#" -ge 1 ] && { printf '%s' "$1"; shift; }
  for a; do printf ' %s' "$a"; done
  printf '\n'
}

# Check if active window is matched with user settings.
# This function covers the standard way to check apps in LO_hasDelayApp
function runcheck(){
    echo "parm1=$1"
    echo "parm2=$2"
    [ $(echo "$1" | grep -ic "$2") -ge 1 ] && [ "$(pidof -s "$2")" ] && return 0
    if [[ "$1" = *$2* ]]; then
        [ "$(pidof -s "$2")" ] && return 0
    fi
    return 1
}

function _lsof(){
    local i=""
    local l=""
    for p in /proc/{0..9}*; do
        i=$(basename "$p")
        for f in "$p"/fd/*; do
            l=$(readlink -e "$f")
            if [ "$l" ]; then
                echo "$i: $l"
            fi
        done
    done | sort -u | sort -n
}

function _lsofdown(){
    local i=""
    local l=""
    for p in /proc/{0..9}*; do
        i=$(basename "$p")
        for f in "$p"/fd/*; do
            l=$(readlink -e "$f")
            if [ "$l" ]; then
                [ $(echo "$l" | grep -ic "downl") -ge 1 ] && echo "$i: $l"
            fi
        done
    done | sort -u | sort -n
}

# find any online stream
function getOnlineMediaWList(){
    local _filt="lbry\|philo\|tubi\|tv\|fubo\|vrv\|disney\|prime vi\|hulu\|tube\|stream\|mp4\|mpeg\|mkv\|mpg\|webm\|vimeo\|anime\|divX\|flix\|rackle\|odcast\|cecast\|cine\|muu\|movie"
    local wLst=$(wmctrl -lxp 2> /dev/null | grep -si "$_filt")
    #local wLst=$(wmctrl -lxp 2> /dev/null)
    [ $? -ne 0 ] && wLst=""
    echo "$wLst"
    return 0
}

# find an online app using sound card
function whichOnlineMediaRunning(){
    local wCls=""
    local wLst="$(getOnlineMediaWList)"
    if [ -n "$wLst" ]; then
        local OLD_IFS=$IFS
        IFS=$'\n'
        local wv=( $wLst )
        for i in "${wv[@]}"; do
            wCls="$(awk '{ print $4 }' <<< "$i" | awk -F[.] '{print $2}' | tr '[:upper:]' '[:lower:]' | tr -d ' ')"
            [ -n "$wCls" ] && IFS=$OLD_IFS && echo "$wCls" && return 0;
        done
        IFS=$OLD_IFS
    fi
    echo "$wCls"
    return 0
}

# Proper Killing processes using kill command
function overkill(){
    echo "overkill $1"
    kill -SIGTERM "$1" > /dev/null 2>&1 || true
    echo "after SIGTERN $1"
    while 2>/dev/null kill -0 "$1"; do
        echo "in while kill $1"
        for SIG in 2 9 ; do 
            if ps -p $1 > /dev/null; then
                echo "for kill $1"
                kill -$SIG "$1" > /dev/null 2>&1 || true; 
                snore 0.3; 
            fi
        done
    done
    return 0
    #ps -p $1 > /dev/null 2>&1 && return 1 || return 0
}

function uptime_active(){
    local Utmc="$(uptime -p | tr -d ',' | tr -s ' ' | sed -e 's/up //g')"
    if [ $(grep -c 'year' <<< "$Utmc") -gt 0 ]; then
        Utmc=$(sed -e 's/year /year, /g' -e 's/years/years,/g' <<< "$Utmc")
    fi
    if [ $(grep -c 'month' <<< "$Utmc") -gt 0 ]; then
        Utmc=$(sed -e 's/month /month, /g' -e 's/months/months,/g' <<< "$Utmc")
    fi
    if [ $(grep -c 'week' <<< "$Utmc") -gt 0 ]; then
        Utmc=$(sed -e 's/week /week, /g' -e 's/weeks/weeks,/g' <<< "$Utmc")
    fi
    if [ $(grep -c 'day' <<< "$Utmc") -gt 0 ]; then
        Utmc=$(sed -e 's/day /day, /g' -e 's/days/days,/g' <<< "$Utmc")
    fi
    if [ $(grep -c 'hour' <<< "$Utmc") -gt 0 ]; then
        Utmc=$(sed -e 's/hour /hour and /g' -e 's/hours/hours and/g' <<< "$Utmc")
    fi
    echo "$Utmc"
}

#==============================================
# Show process name of a PID
#==============================================
function psname(){
    if [ -n "$1" ]; then ps -p $1 -o comm= ;return 0; fi
    echo "Usage: psname <PID>" && return 1
}

#==============================================
# Return string length (Locale based)
#==============================================
function strLen(){
    [ -z "$1" ] && echo "Usage: strLen <string>" && return 1
    local bytlen
    bytlen=${#1}
    echo  $bytlen
}

#==============================================
# Return string length (LANG=C)
#==============================================
function strLenC(){
    [ -z "$1" ] && echo "Usage: strLenC <string>" && return 1
    local bytlen
    local oLang=$LANG
    LANG=C
    bytlen=${#1}
    LANG=$oLang
    echo $bytlen
}

#==============================================
# Return diff between locale systems for a string
#==============================================
function strU8DiffLen(){
    [ -z "$1" ] && echo "Usage: strU8DiffLen <string>" && return 1
    local bytlen oLang=$LANG
    LANG=C
    bytlen=${#1}
    LANG=$oLang
    echo $(( bytlen - ${#1} ))
}

function hosts_up(){
    local ip_local=$(ip -br -h -4 address | grep "UP" | awk '/UP/{print $3}' | sed -e 's/\/24//g')
    local ip_neig=$(ip -br -h -4 neigh | awk '{print $1}')
    echo -e "$ip_local\n$ip_neig" | sort
}

# Check var for set and not null
function var_is_set() { [ "${1+x}" = "x" ] && [ "${#1}" -gt "0" ]; }
# Check var for unset
function var_is_unset() { [ -z "${1+x}" ]; } 
# Check var for set and null
function var_is_empty() { [ "${1+x}" = "x" ] && [ "${#1}" -eq "0" ]; }
# Check var for unset, or set and null
function var_is_blank() { var_is_unset "${1}" || var_is_empty "${1}"; }

#==============================================
# qh - Search bash history for a command.
#
# Examples:
#    qh ls 
#
# @param {String} $*  search string
#==============================================
function qh() {
    local _cmd="";
    local _parm="$*"
    if [ -z "$HISTFILE" ]; then 
        export HISTFILE="$HOME/.bash_history"
    fi
    if hash fzy > /dev/null 2>&1 ; then
        _cmd=$(grep "$*" "$HISTFILE" | fzy)
        [ -n "$_cmd" ] && eval "$_cmd"
    elif hash fzf > /dev/null 2>&1 ; then
        _cmd=$(grep "$*" "$HISTFILE" | fzf)
        [ -n "$_cmd" ] && eval "$_cmd"
    elif hash pick > /dev/null 2>&1 ; then
        _cmd=$(grep "$*" "$HISTFILE" | pick)
        [ -n "$_cmd" ] && eval "$_cmd"
    elif hash hstr > /dev/null 2>&1 ; then
        hstr "$*"
    fi 
}

function context() {
    if [ -t 0 ];  then
        if [ -t 1 ]; then
            file $( readlink /proc/$$/fd/0 ) | grep -i "character special"
            echo "no pipes"
            echo "$@"
            echo " "
        else
            echo "pipe out only"
        fi
    else
        echo "$$"
        readlink /proc/$$/fd/0 | grep -i "^pipe:"
        if [ -t 1 ]; then
            echo "pipe in only"
            [ -p /dev/stdin ] && echo "dev/stdin is a pipe" && cat /dev/stdin
            echo " "
        else
            echo "pipe in and out"
            [ -p /dev/stdin ] && echo "dev/stdin is a pipe" && cat /dev/stdin
            [ -p /dev/stout ] && echo "dev/stout is a pipe"
            echo " "
        fi
    fi
}

function remove-lines() {
  local remove_lines="$1"
  local all_lines="$2"
  local tmp_file="$(mktemp)"
  grep -Fvxf "$remove_lines" "$all_lines" > "$tmp_file"
  mv "$tmp_file" "$all_lines"
}

function XorgIDproc(){
    local WINDOW_IDS=$(xwininfo -tree -root | grep -o -P '\b0x[0-9a-f]+' | sort -u)

    local PIDS=""
    local PID=""
    for ID in $WINDOW_IDS; do
        if [ "$ID" = "0x0" ]; then
            continue
        fi
        #printf "Window %s PID=" "$ID" 
        PID=$(LC_ALL=C xprop -id "$ID" _NET_WM_PID | cut -d' ' -f3-)
        if [ "$PID" = "not found." ]; then
            printf "%s\n" "$ID is unknown)"
        #   See also: https://unix.stackexchange.com/a/84981
            true;
        else
        #   printf "%s\n" "$PID"
            PIDS="$PIDS $PID"
        fi
    done
    
    PIDS=$(printf "%s\n" $PIDS | sort -u)
    
    # go through the list of processes connected to Xorg:
    for P in $PIDS; do
        printf "%s: %s\n" "$P" "$(cat /proc/$P/cmdline)"
        # wait for the previous line to get on the screen before stopping e.g. compositing manager
        sleep 0.1s 
        # Stop the process for 5 secs and let the process continue after that.
        kill -STOP "$P" && sleep 5s && kill -CONT "$P"
    done
}

# Diff between dates in seconds
function dateDiffS() {
    local d1=$(date -d "$1" +%s)
    local d2=$(date -d "$2" +%s)
    echo $(( (((d1-d2) > 0 ? (d1-d2) : (d2-d1))) ))
}

# Diff between dates in days
function dateDiffD() {
    local d1=$(date -d "$1" +%s)
    local d2=$(date -d "$2" +%s)
    echo $(( (((d1-d2) > 0 ? (d1-d2) : (d2-d1)) + 43200) / 86400 ))
}

# Snores until a date/time has come
function snoreUntil {
    local seconds=0
    # Use $* to eliminate need for quotes
    seconds=$(( $(date -d "$*" +%s) - $(date +%s) ))
    [ $? -ne 0 ] && echo "Invalid date/time specification" && return 1
    [ $seconds -le 0 ] && echo "Date/time must be greater than current date/time" && return 1
    echo "Sleeping for $seconds seconds"
    snore $seconds
}

# Sleep for a really small fraction of time
#  Ex: to sleep for 250 milliseconds ==> select(undef, undef, undef, 0.25);
function sleep_fraction() {
  /usr/bin/perl -e "select(undef, undef, undef, $1)"
}

# Waits while adjusting overhead until a certain date/time has come
# this function takes in account system date/time changes
function sleepUntil() {
    local wDt=$(date -d "$*"  +"%Y%m%d%H%M%S")
    [ $? -ne 0 ] && echo "Invalid date/time specification" && return 1
    local wScs=$(date -d "$*"  +"%s")
    local cDt=$(date +"%Y%m%d%H%M%S")
    local cScs=0
    local dScs=0
    echo "Sleeping until $wDt"
    while (( $cDt < $wDt )); do
        # Snores in amounts of seconds
        if [ $dScs -gt 600 ]; then
            #echo "snore 600: time = $cDt"
            snore 600
        elif [ $dScs -gt 300 ]; then
            #echo "snore 300: time = $cDt"
            snore 300
        elif [ $dScs -gt 150 ]; then
            #echo "snore 150: time = $cDt"
            snore 150
        elif [ $dScs -gt 60 ]; then
            #echo "snore 60: time = $cDt"
            snore 60
        elif [ $dScs -gt 30 ]; then
            #echo "snore 30: time = $cDt"
            snore 30
        elif [ $dScs -gt 15 ]; then
            #echo "snore 15: time = $cDt"
            snore 15
        elif [ $dScs -gt 7 ]; then
            #echo "snore 7: time = $cDt"
            snore 7
        elif [ $dScs -gt 5 ]; then
            #echo "snore 5: time = $cDt"
            snore 5
        elif [ $dScs -gt 3 ]; then
            #echo "snore 3: time = $cDt"
            snore 3
        elif [ $dScs -gt 2 ]; then
            #echo "snore 2: time = $cDt"
            snore 2
        fi
        cDt=$(date +"%Y%m%d%H%M%S");
        cScs=$(date +"%s")
        dScs=$((wScs - cScs))
        #echo "here again secs = $dScs"
        snore 0.45
    done
}

function doMenu() {
    local wpath="${*:-$HOME}"  
    local dpath=""
    dpath=$(esc_enc $wpath)
    echo " ini - wpath = $wpath ==> dpath = $dpath ..."
    doMenu_files "en" "$wpath"
}

function doMenu_files() {
    local old_IFS=$IFS
    [ -z "$1" ] && return 0
    local llang="$1"
    shift
    local extra_entries=""
    local directories_menu=""
    local files_menu=""
    local shortname=""
    local dname=""
    local dpath=""
    local path=""
    local sdname=""

    path="${*:-$HOME}"  # default starting place is ~, otherwise $2
    path="$(echo "${path}"/ | tr -s '/')"    # ensure one final slash
    local tmp=$(realpath $path)
    [ -d "$path" ] || { echo  "$0 : $path is not a directory"; return 1; }
    [ "$path" = "$HOME"/ ] && extra_entries="$shown_dotfiles"
    [ "$path" = "$HOME"/ ] && echo "$0 : path is home directory and extra_entries = $extra_entries"
    IFS=$'\n'
    lstfile=$(/bin/ls $path -L1h --group-directories-first )
    dpath=$(esc_enc $path)

    echo "llang = $llang"
    echo "path = $path"
    echo "dpath = $dpath"
    #echo "tmp = $tmp"
    #echo "lstfile = $lstfile"
    echo "$path"

    for i in "$path"*; do
    #for i in $lstfile; do
        #[ -e "$i" ] || continue;    # only output code if file exists
        shortname="${i##*/}";
        dname=$(esc_enc $shortname);
        echo "shortname = $shortname"
        #echo "dname = $dname"
        [ -d "$path$shortname" ] && echo "$path$shortname is a directory - menu ==> ${dpath}${dname} ${dname} $0 &quot;$path$dname&quot;"
        if [ -f "$path$shortname" ]; then
            if [ -x "$path$shortname" ]; then
                echo "$path$shortname is an executable file - menu ==> ${dpath}${dname} ${dname} $aux_pipe &quot;$path$dname&quot;"
            else
                echo "$path$shortname is a normal file - menu ==> ${dname} <![CDATA[$0 --open ${dpath}${dname}]]>"
            fi
        fi
        #echo "directories_menu = $directories_menu"
        #echo "files_menu = $files_menu"
        #echo "sdname = $sdname"
    done
    IFS=$old_IFS
    echo "extra_entries = $extra_entries"
    for i in $extra_entries; do
        #[ -e "$i" ] || continue;    # only output code if file exists
        shortname="${i##*/}";
        #echo "$dpath$dname"
        dname=$(esc_enc $shortname);
        [ -d "$path$shortname" ] && echo "$path$shortname is a directory - menu ==> ${dpath}${dname} ${dname} $0 &quot;$path$dname&quot;"
        [ -f "$path$shortname" ] && echo "$path$shortname is a normal file - menu ==> ${dname} <![CDATA[$0 --open ${dpath}${dname}]]>"
    done
}

function main() {
    #echo "--------------------------"
    #echo " teste snore"
    #echo "--------------------------"
    #echo $(date +"%H:%M")
    #for i in {0..600}; do
    #    snore 0.1
    #done
    #echo $(date +"%H:%M")
    #echo "--------------------------"
    #echo " teste sleep"
    #echo "--------------------------"
    #echo $(date +"%H:%M")
    #for i in {0..600}; do
    #    sleep 0.1
    #done
    #echo $(date +"%H:%M")
    #echo "--------------------------"
    #echo " teste dateDiffS"
    #echo "--------------------------"
    #date -d "now"
    #date -d "tomorrow 12:40"
    #local tmp=$(dateDiffS "now" "tomorrow 12:40")
    #echo "dateDiffS = $tmp seconds"
    #echo "--------------------------"
    #echo " teste dateDiffD"
    #echo "--------------------------"
    #date -d "now"
    #date -d "2024/09/29 15:50"
    #local tmp=$(dateDiffD "now" "2024/09/29 15:50")
    #echo "dateDiffD = $tmp days"
    #echo "--------------------------"
    #echo " teste snoreUntil"
    #echo "--------------------------"
    #echo "examples:"
    #echo "  snoreUntil 8:24"
    #echo "  Sleeping for 35 seconds"
    #echo "  snoreUntil '23:00'"
    #echo "  Sleeping for 52489 seconds"
    #echo "  snoreUntil 'tomorrow 1:00'"
    #echo "  Sleeping for 59682 seconds"
    #echo "Running:  "
    #snoreUntil "2024/09/28 15:50"
    #sleepUntil "$@"; date +"Now, it is: %T";
    #time sleep_fraction 0.10
    #for i in $(pgrep -u usuario | grep -v "gvfs\|systemd\|(sd-pam)\|gconf\|dconf\|dbus\|openbox"); do
    #    echo "$i" 
    #done
    #local OLD_IFS=$IFS
    #IFS=$'\n'
    #for i in $(pgrep -lf -u usuario | grep "zathura"); do
    #    overkill $(awk '{print $1}' <<< $i)
    #done
    doMenu
}

main "$@"

