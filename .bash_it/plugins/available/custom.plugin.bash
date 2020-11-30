# 'custom' functions

#==============================================
# Oneliners
#==============================================
# Random passw. ex: rpass 6
function rpass(){ cat /dev/urandom | tr -cd '[:graph:]' | head -c ${1:-12}; }
# Return system load as percentage, i.e., '40' rather than '0.40)'.
function sys_load(){ local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.');  echo $((10#$SYSLOAD)) ; }
# Crypt file using ascii armor
function aencrypt(){ gpg -ac --no-options "$1" ; }
# Crypt binary file. jpegs/gifs/vobs/etc.
function bencrypt(){ gpg -c --no-options "$1" ; }
# Drcrypt (with no options)
function decrypt(){ gpg --no-options "$1" ; }
# Number of CPUs
function ncpu(){ grep -c 'processor' /proc/cpuinfo ; }
# Custom ps my user processes
function my_ps(){ ps -eo etimes,ruser,pid,ppid,cmd --sort=start_time | awk 'BEGIN{now=systime()} {$1=strftime("%Y-%m-%d-%H:%M:%S", now-$1); print $0}' | awk -v u=$USER '$2 == u { print $0 }' | grep -v "grep" | grep -v "awk"; }
# Custom my user processes tree
function psgrep(){ my_ps | awk '!/awk/ && $0~var' var="${1:-".*"}" | grep -v "grep" | grep -v "awk" ; }
# Submit a job
function submit(){ ($1 &) ;}
# Color tree of current dir
function lsr(){ tree -ChvugapfF --dirsfirst | most -ct4 +82 +s ; }
# Reset terminal
function cls(){ printf "%b" "\ec"; }
# Decode base64
function decode_64(){ echo "$@" | base64 -d ; }
# Encode base64
function encode_64(){ echo "$@" | base64 - ; }
# DICTIONARY FUNCTIONS
function dwordnet(){ curl dict://dict.org/d:"${1}":wn; }
function dacron(){ curl dict://dict.org/d:"${1}":vera; }
function djargon(){ curl dict://dict.org/d:"${1}":jargon; }
function dfoldoc(){ curl dict://dict.org/d:"${1}":foldoc; }
function dthesaurus(){ curl dict://dict.org/d:"${1}":moby-thes; }
# Hour (24 h format)
function hora(){ date -Ins | cut -b 12-19 ; }
# Date ISO format
function dateiso(){ date -Ins | cut -b 1-10 ; }
# Data (european format)
function dateeur(){ date +"%d-%m-%Y" ; }
# Date n days ago
function yday(){ local dstr="date --date='-$1 day'"; eval "$dstr"; }
# Date +n dias ahead
function tday(){ local dstr="date --date='+$1 day'"; eval "$dstr"; }
# Top count lines
function topcount(){ sort | uniq -c | sort -rn | head -n "${1:-10}"; }
# Most color
function mostcolor(){ cat "$1" | sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[%sm %s \x1b[0m",(i%7)+31,$i);print ""}' | most -RS; }
# Uptime since
function uptime_since(){ uptime -ps ; }
# Free memory
function free_mem(){ awk '/MemFree/{print $2"M"}' /proc/meminfo ; }
# Total memory
function total_mem(){ awk '/MemTotal/{print $2"M"}' /proc/meminfo ; }
# Available memory
function avail_mem(){ awk '/MemAvailable/{print $2"M"}' /proc/meminfo ; }
# Fuzzy find file
function ff(){ find . -type f -iname "$*";}
# Find a file with a pattern in name:
function ff_f(){ find . -type f -iname '*'"$*"'*';}
# Fuzzy find dir
function fd(){ find . -type d -iname "$*";}
# Find a dir with a pattern in name:
function fd_f(){ find . -type d -iname '*'"$*"'*';}
# Number of active jobs
function jobs_count(){ jobs -r | wc -l | sed -e "s/ //g" ; }
# Number of stopped jobs
function stoppedjobs(){ jobs -s | wc -l | sed -e "s/ //g" ; }
# Laptop battery %
function laptop_battery(){ upower -i "$(upower -e | grep 'BAT')" | grep -E "state|to\ full|percentage" ; }
# Mouse battery %
function mouse_battery(){ upower -i "$(upower -e | grep 'mouse')" | grep -E "state|to\ full|percentage" ; }
# Simple backup
function bak(){ cp "$1" "$1_$(date +%Y-%m-%d_%H:%M:%S).bak" ; }
# Generate space report
function space(){ du -skh * | sort -hr ; }
# Processor info
function core(){ cat /proc/cpuinfo | grep "model name" | cut -c14- ; }
# Graphic card
function graph(){ lspci | grep -i vga | cut -d: -f3 ; }
# Ethernet card
function ethcard(){ lspci | grep -i ethernet | cut -d: -f3 ; }
# Wireless card
function wfcard(){ lspci | grep -i network | cut -d: -f3 ; }
# Display on a desired via pipe (ex: cmd1 | ongreen)
function onblack(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;30m %s \x1b[0m",$i);print ""}'; }
function onred(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;31m %s \x1b[0m",$i);print ""}'; }
function ongreen(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;32m %s \x1b[0m",$i);print ""}'; }
function onyellow(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;33m %s \x1b[0m",$i);print ""}'; }
function onblue(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;34m %s \x1b[0m",$i);print ""}'; }
function onmagenta(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;35m %s \x1b[0m",$i);print ""}'; }
function oncyan(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;36m %s \x1b[0m",$i);print ""}'; }
function onwhite(){ sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;37m %s \x1b[0m",$i);print ""}'; }
# Commandline FU MOTD
function cm_fu_motd(){ curl http://www.commandlinefu.com/commands/random/plaintext -o "$HOME"/.motd -s -L && cat "$HOME"/.motd ; }
# Command line Calculations
function calc(){ printf '%s\n' "scale=3;${*//[ ]}" | bc -l ; }
# Run dig and display the most useful info
function digga(){ dig +nocmd  any +multiline +noall +answer "$1"; }
# tre is a shorthand for tree with hidden files and color enabled, ignoring .git directory, listing directories first.
function tre(){ tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | most -N; }
# Pre append a path to the PATH
function prepend-path(){ [ -d "$1" ] && PATH="$1:$PATH" ; }
# Show duplicate/unique lines
function duplines(){ sort "$1" | uniq -d ; }
# Show unique lines
function uniqlines(){ sort "$1" | uniq -u ; }
# Get IP from hostname
function hostname2ip(){ ping -c 1 "$1" | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' ; }
# Echo assertion fail
function echo_fail(){ printf "%s \e[31m[✘] " "$@";  echo -e "\033[0m" ; }
# Echo assertion pass
function echo_pass(){ printf "%s \e[32m[✔] " "$@";  echo -e "\033[0m"; }
# Appends your key to a server's authorized keys file
function authme(){ ssh "$1" 'cat >>.ssh/authorized_keys' <~/.ssh/id_rsa.pub ; }
# Web helper get
function couch-get(){ curl -s -X GET "$@" 2>&1 ; }
# Web helper put
function couch-put(){ curl -s -X PUT "$@" 2>&1 ; }
# Web helper post
function couch-post(){ curl -s -X POST "$@" 2>&1 ; }
# Web helper delete
function couch-delete(){ curl -s -X DELETE "$@" 2>&1 ; }
# Hexadecimal conversion
function decimal2hex(){ echo 16o "$1" p | dc ; }
# Rsync simple backup
function rsync_bpk(){ rsync "$1" -rvhzI --size-only --inplace --human-readable --compress --compress-level=1 "$2" ; }
# Dir count
function _dir_count(){ /bin/ls -lagFXh1 | grep '/' | awk '!/\.\./' | awk '!/\.\//' | /usr/bin/wc -l | /bin/sed 's: ::g' ; }
# File count
function _file_count(){ /bin/ls -lagFXh1 | grep '\-rw' | /usr/bin/wc -l | /bin/sed 's: ::g' ; }
# Current pwd_dir size
function _pwd_size(){ /bin/ls -lagFXh1 | /bin/grep -m 1 total | /bin/sed 's/total //' ; }
# Commit and push everything
function gitdone(){ git add -A; git commit -S -v -m "$1"; git push; }
# Strip a pattern from a string. Usage: astrip "The Quick Brown Fox" "[aeiou]"
function astrip(){ printf "%s\\n" "${1//$2}"; }
# Strip characters from the end of a string. Usage: rstrip "The Quick Brown Fox" "Fox"
function rstrip(){ printf "%s\\n" "${1%%$2}"; }
# Strip characters from the start of a string. Usage: lstrip "The Quick Brown Fox" "The"
function lstrip(){ printf "%s\\n" "${1##$2}"; }
# Lowercase a string. Usage: lower "string"
function lower(){ printf "%s\\n" "${1,,}"; }
# Uppercase a string. Usage: lower "string"
function upper(){ printf "%s\\n" "${1^^}"; }
# Check var for set and not null
function var_is_set() { [ "${1+x}" = "x" ] && [ "${#1}" -gt "0" ]; }
# Check var for unset
function var_is_unset() { [ -z "${1+x}" ]; } 
# Check var for set and null
function var_is_empty() { [ "${1+x}" = "x" ] && [ "${#1}" -eq "0" ]; }
# Check var for unset, or set and null
function var_is_blank() { var_is_unset "${1}" || var_is_empty "${1}"; }


#==============================================
# undup_bash_history - Remove all duplicated lines from bash_history file.
#
# Examples:
#    undup_bash_history
#==============================================
function undup_bash_history(){
    tac $HISTFILE | awk '!x[$0]++' | tac | sponge $HISTFILE
    history -c
    history -r
}

#==============================================
# qh - Search bash history for a command.
#
# Examples:
#    qh ls 
#
# @param {String} $*  search string
#==============================================
function qh(){
    if hash hstr; then
        hstr "$*"
    else
        #          ┌─ enable colors for pipe
        #          │  ("--color=auto" enables colors only if
        #          │  the output is in the terminal)
        grep --color=always "$*" "$HISTFILE" |       less -RXS#3M~g
        # display ANSI color escape sequences in raw form ─┘│
        #       don't clear the screen after quitting less ─┘
    fi 
}

#==============================================
# qtxt - Search for text within the current directory.
#
# Examples:
#    qtxt test 
#
# @param {String} $*  search string
#==============================================
function qtxt(){
    #     ┌─ ignore case
    #     │┌── search all files under each directory, recursively
    grep -iRn --color=always "$*" --exclude-dir=".git" --exclude-dir="node_modules" . | less -RXS#3M~g
    #       display ANSI color escape sequences in raw form ─────────────────────────────────┘│
    #           don't clear the screen after quitting less ───────────────────────────────────┘
}

#==============================================
# position_cursor - Set cursor positon to a fixed location
#
# Examples:
#    position_cursor
#==============================================
function position_cursor(){
    local RES_COL
    let RES_COL=$(tput cols)-12
    tput cuf $RES_COL
    tput cuu1
}

#==============================================
# display_status - Display status using colors
#
# Examples:
#    display_status ok
#
# @param {String} $1  status description 
#==============================================
function display_status(){
    [ -z "$1" ] && echo " " && return 0
    local stt="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
    local stt_cl
    case $stt in
        OK)
            stt="   OK    "
            stt_cl="$_cl_green"
        ;;
        PASSED)
            stt=" PASSED  "
            stt_cl="$_cl_green"
        ;;
        SUCCESS)
            stt=" SUCCESS "
            stt_cl="$_cl_green"
        ;;
        FAILURE | FAILED | ERROR)
            stt=" FAILURE "
            stt_cl="$_cl_red"
        ;;
        INFO | NOTE | NOTICE)
            stt=" NOTICE  "
            stt_cl="$_cl_blue"
        ;;
        WARNING | WARN )
            stt=" WARNING "
            stt_cl="$_cl_yellow"
        ;;
    esac
    position_cursor
    echo "[$_cl_bold$stt_cl$stt$_cl_reset]"
    return 0
}

#==============================================
# is_installed - Verify if such an APT package exists
#
# Examples:
#    is_installed firefox
#
# @param {String} $1  package name 
#==============================================
function is_installed(){
    [ $# -eq 0 ] && echo "Usage: is_installed package_name" && return 1;
    command -v apt-file &>/dev/null
    if [ $? -eq 0 ]; then
        local BINARY="$(realpath $(command -v $@) 2>/dev/null)"
        [ -z "$BINARY" ] && BINARY="$@"
        local PACKAGE="$(apt-file search $BINARY | grep -E ":.*[^-.a-zA-Z0-9]${BINARY}$" | awk -F ":" '{print $1}' | sort -u | head -n 1 )"
    else
        local PACKAGE="$@"
    fi
    dpkg -s "$PACKAGE" &>/dev/null
    [ $? -eq 0 ] && echo_pass "Package $PACKAGE is installed!" && return 0
    echo_fail "Package $PACKAGE is NOT installed!"
    return 1
}

#==============================================
# ip_inf - Shows detailed IP info about a host
#
# Examples:
#    ip_inf google.com
#
# @param {String} $1  URL to inspect
#==============================================
function ip_inf(){
    [ -z "$1" ] && echo " " && return 1
    if grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" <<< "$1"; then
        curl ipinfo.io/"$1"
        return 0
    else
        host "$1" > /dev/null
        if [ $? -eq 0 ]; then
            local ipawk=($(host "$1" | awk '/address/ { print $NF }'));
            curl ipinfo.io/"${ipawk[0]}"
            return 0
        else
            echo "Host: $1 not found."
            return 1
        fi
    fi
    echo " "
    return 1
}

#==============================================
# is_newer - compare the dates of two files
#
# Examples:
#    is_newer file1 file2
#
# @param {String} $1  Filename1
# @param {String} $2  Filename2
#==============================================
function is_newer(){
    [ $# -ne 2 ] && echo "Usage: is_newer file1 file2" && return 1
    # Some file not found
    [ ! -f "$1" -o ! -f "$2" ] && return 1
    [ -n "$(find "$1" -newer "$2" -print)" ] && return 0 || return 1
}

#==============================================
# is_systype - compare string with current system and return true (0) if it matches uname command
#
# Examples:
#   is_systype "Linux"
#
# @param {String} $1  SystemType string
#==============================================
function is_systype(){
    [ -z "$1" ] && echo "Usage: is_systype <string>" && return 1
    if [ "$1" = "$(uname -s)" ]; then
        return 0
    elif [ "$1" = "$(uname -m)" ]; then
        return 0
    else
        case $(uname -r) in
            "$1"* ) 
                return 0 
            ;;
        esac
    fi
    return 1
}

#==============================================
# is_alpha - Ensures that input only consists of alphabetical and numeric characters.
#
# Examples:
#   is_alpha "T-Rex"
#
# @param {String} $1 string
#==============================================
function is_alpha(){
    [ -z "$1" ] && echo "Usage: is_alpha <string>" && return 1
    [ "$(echo "$1" | sed -e 's/[^[:alnum:]]//g')" != "$1" ] && return 1 || return 0
}

#==============================================
# is_int - Ensures that input only consists of numeric characters and initial sign.
#
# Examples:
#   is_int "001"
#
# @param {String} $1 string
#==============================================
function is_int(){
    [ -z "$1" ] && echo "Usage: is_int <string>" && return 1
    local number="$1";
    local testvalue="";
    if [ "${number%${number#?}}" == "-" ] ; then   # first char '-' ?
        testvalue="${number#?}"     # all but first character
    else
        testvalue="$number"
    fi
    [ -z "$testvalue" ] && return 1
    [ -n "$(echo "$testvalue" | sed 's/[[:digit:]]//g')" ] && return 1
    return 0
}

#==============================================
# is_float - Ensures that input only consists of numeric characters, sign and decimal sep.
#
# Examples:
#   is_float ".25"
#
# @param {String} $1 string
#==============================================
function is_float(){
    [ -z "$1" ] && echo "Usage: is_float <string>" && return 1

    local fvalue="$1"
    local pt=$(echo "$fvalue" | sed 's/[^.]//g')

    if [ -n "$pt" ] ; then
        local decimalPart=$(echo "$fvalue" | cut -d. -f1)
        local fractionalPart=$(echo "$fvalue" | cut -d. -f2)
        if [ -n "$decimalPart" ] ; then
            if [ "$decimalPart" != "-"  ] ; then
                if ! is_int "$decimalPart" ; then
                    return 1
                fi
            fi
        fi
        if [ "${fractionalPart%${fractionalPart#?}}" == "-" ] ; then
            return 1
        fi
        if [ "$fractionalPart" != "" ] ; then
            if ! is_int "$fractionalPart" ; then
                return 1
            fi
        fi
        if [ "$decimalPart" == "-"  ] ; then
            if [ -z "$fractionalPart" ] ; then
                return 1
            fi
        fi
    else
        if [ "$fvalue" == "-" ] ; then
            return 1
        fi
        if ! is_int "$fvalue" ; then
            return 1
        fi
    fi
    return 0
}

#==============================================
# serve_py - Start an HTTP server from a directory, optionally specifying the port
#
# Examples:
#   serve_py
#   serve_py 8080
#
# @param {String} $1 port number
#==============================================
function serve_py(){
    local port="${1:-8000}";
    # Set the default Content-Type to text/plain instead of application/octet-stream
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

#==============================================
# get_full_path - Get full file/directory path
#
# Examples:
#   full_path=$(get_full_path '/tmp');       # /tmp
#   full_path=$(get_full_path '~/..');       # /home
#   full_path=$(get_full_path '../../../');  # /home
#
# @param {String} $1 - relative path
# @returns {String} absolute path
#==============================================
function get_full_path(){
    local user_home="${HOME//\//\\\/}";
    local user_home_sed="s#~#${user_home}#g";
    local rel_path=$(echo "${1}" | sed "${user_home_sed}");
    local result=$(readlink -e "${rel_path}");
    echo "${result}";
}

#==============================================
# exesudo - Execute a function or alias with sudo
#
# Examples:
#   exesudo "funcname" followed by any param
#   exesudo psonly mdm
#
# @Params {String} $1:   name of the object to be executed with sudo
# @Params {String} $2:   arg1 
# @Params {String} $..:  argn 
#==============================================
# Luca Borrione  2012
#==============================================
function exesudo(){
    [ $# -eq 0 ] && "Usage: exesudo <cmd> <arg1> <arg2> <arg3> ..." && return 0
    local _funcname_="$1"
    local params=( "$@" )       ## array containing all params passed here
    local tmpfile=$(mktemp)     ## temporary file
    local content               ## content of the temporary file
    local regex="\s+"           ## regular expression
    local func                  ## object source
    # Shift the first param (which is the name of the object)
    unset params[0]             ## remove first element
    params=( "${params[@]}" )   ## repack array
    # Delete existing older file 
    [ -f "$tmpfile" ] && rm -f "$tmpfile"
    # bash header for TEMPORARY FILE:
    content="#!/usr/bin/env bash\n\n"
    # Write the params array
    content="${content}params=(\n"
    for param in "${params[@]}"; do
        if [[ "$param" =~ $regex ]]; then
            content="${content}\t\"${param}\"\n"
        else
            content="${content}\t${param}\n"
        fi
    done
    content="$content)\n"
    echo -e "$content" > "$tmpfile"
    echo "#$(type "$_funcname_")" >> "$tmpfile"
    echo -e "\n$_funcname_ \"\${params[@]}\"\n" >> "$tmpfile"
    sudo bash "$tmpfile"
    [ -f "$tmpfile" ] && rm -f "$tmpfile"
}

#==============================================
# sv_get - Rsync pull from server
#
# @option -h:   help
# @option -u:   Set a remote username
# @option -s:   Set a remote hostname
#
# @param {String} $1 - path from
# @param {String} $2 - path to
#==============================================
function sv_get(){
    function this_usage(){
        echo "Usage:  sv_get [options] PATH_FROM PATH_TO."
        echo "Purpose: rsync to pull files from servername."
        echo "       "
        echo "Mandatory arguments: "
        echo "PATH_FROM: Path on server to Rsync from"
        echo "PATH_TO:   Path on local to Rsync to"
        echo "       "
        echo "Options"
        echo "-h:   Show this help"
        echo "-u:   Set a remote username (if not set your LOCAL USER variable will be used)"
        echo "-s:   Set a remote hostname (if not set your LOCAL HOSTNAME variable will be used)"
        echo "Example."
        echo "This:"
        echo "sv_get -u server_username -s server.address.edu.au /home/server/path/*.py ./temp"
        echo "       "
        echo "Becomes:"
        echo "rsync -avz --progress server_username@server.address.edu.au:/home/server/path/*.py ./temp"
    }
    local usr_name=""
    local srv_name=""

    local OPTIND=1
    while getopts "u:s:h" opt; do
        case $opt in
            u) usr_name=$OPTARG ;;
            s) srv_name=$OPTARG ;;
            h) this_usage; return;;
            *) return 1;;
        esac
    done
    shift $((OPTIND-1))

    if [[ -z "$usr_name" ]] ; then
        usr_name=$USER ;
    fi

    if [[ -z "$srv_name" ]] ; then
        srv_name=$HOSTNAME ;
    fi

    if [[ ( $# -eq 0 ) || ( "$1" == "" ) || ( "$2" == "" ) ]] ; then
        this_usage ;
        return 1
    fi
    echo "rsync -avz --progress $usr_name@$srv_name:$* "
    rsync -avz --progress $usr_name@$srv_name:$* 
}

#==============================================
# sv_put - Rsync push to a server
#
# @option -h:   help
# @option -u:   Set a remote username
# @option -s:   Set a remote hostname
#
# @param {String} $1 - path from
# @param {String} $2 - path to
#==============================================
function sv_put(){
    function this_usage(){
        echo "Usage:   sv_put [options] PATH_FROM PATH TO."
        echo "Purpose: rsync to push files to servername."
        echo "       "
        echo "Mandatory arguments: "
        echo "PATH_FROM: Path on local to Rsync from"
        echo "PATH_TO:   Path on server to Rsync to"
        echo "       "
        echo "Options"
        echo "-h:   Show this help"
        echo "-u:   Set a remote username (if not set your LOCAL USER variable will be used)"
        echo "-s:   Set a remote hostname (if not set your LOCAL HOSTNAME variable will be used)"
        echo "Example."
        echo "This:"
        echo "sv_put -u server_username -s server.address.edu.au /home/server/path/*.py /temp"
        echo "       "
        echo "Becomes:"
        echo "rsync -avz --progress /home/server/path/*.py server_username@server.address.edu.au:/temp"
    }
    local usr_name=""
    local srv_name=""

    local OPTIND=1
    while getopts "u:s:h" opt; do
        case $opt in
            u) usr_name=$OPTARG ;;
            s) srv_name=$OPTARG ;;
            h) this_usage; return;;
            *) return 1;;
        esac
    done
    shift $((OPTIND-1))

    if [[ -z "$usr_name" ]] ; then
        usr_name=$USER ;
    fi

    if [[ -z "$srv_name" ]] ; then
        srv_name=$HOSTNAME ;
    fi

    if [[ ( $# -eq 0 ) || ( "$1" == "" ) || ( "$2" == "" ) ]] ; then
        this_usage ;
        return 1
    fi

    #grabs last passed argument..
    for last; do true; done

    #grabs all arguments but the last one...
    #echo ${@:1:$(($#-1))}

    echo "rsync -avz --progress ${@:1:$(($#-1))} $usr_name@$srv_name:$last"
    rsync -avz --progress ${@:1:$(($#-1))} $usr_name@$srv_name:$last
}

#==============================================
#  get_xserver - Get remote host of the session (empty for localhost).
#
# Examples:
#   get_xserver
#==============================================
function get_xserver(){
    echo "$(LC_ALL=C who am i | grep  '(' | awk '{print $NF}' | tr -d ')''(' )"
}

#==============================================
#  set_display - Automatic setting of $DISPLAY (if not set already).
#
# Examples:
#   set_display
#==============================================
function set_display(){
    if [ -z ${DISPLAY:=""} ]; then
        local XSERVER=$(get_xserver)
        if [[ -z ${XSERVER} || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
            DISPLAY=":0"                # Display on local host.
        else
            DISPLAY="$XSERVER:0.0"      # Display on remote host.
        fi
    fi
    export DISPLAY
}

#==============================================
# exists_fileordir - Checks to see if a file or directory already exists
#
# Examples:
#   exists_fileordir "/home" 
#
# @Params {String} $1: directory or filename
#==============================================
function exists_fileordir(){
    [[ -e $1 && ! -L $1 ]] && [[ -f $1 ||  -d $1 ]] && return 0
    return 1
}

#==============================================
# is_active - Check if a service is active on systemd
#
# Examples:
#   is_active "ssh" 
#
# @Params {String} $1: service name
#==============================================
function is_active(){
    [ -z "$1" ] && echo "Usage: is_active <service name>" && return 1
    [ "$(systemctl is-active $1)" == "active" ] && return 0 || return 1
}

#==============================================
# activate - Activate a systemd service
#
# Examples:
#   activate "ssh" 
#
# @Params {String} $1: service name
#==============================================
function activate(){
    [ -z "$1" ] && echo "Usage: activate <service name>" && return 1
    [ is_active "$1" ] && return 0
    sudo systemctl enable "$1"
    sudo systemctl start "$1"
}

#==============================================
# deactivate - Deactivate a systemd service
#
# Examples:
#   deactivate "ssh" 
#
# @Params {String} $1: service name
#==============================================
function deactivate(){
    [ -z "$1" ] && echo "Usage: deactive <service name>" && return 1
    [ is_active "$1" ] && sudo systemctl stop "$1"
}

#==============================================
# t - A tree alternative
#
# Examples:
#   t "/home" 
#
# @Params {String} $1: directory name
#==============================================
function t(){
    local pth="$(readlink -m "${1:-$PWD}")"
    [ -n "$1" ] && shift
    find "$pth" "$@" -print | sed "2,\$s;${pth%/*}/;;;2,\$s;[^/]*/; |- ;g;s;-  |;   |;g"
}

#==============================================
# gen_lock - Generate a lock file for a script
#
# Examples:
#   gen_lock "myscript" 
#   gen_lock "myscript" 190
#
# @Params {String} $1: file name
# @Params {String} $2: file descriptor (default 200)
#==============================================
function gen_lock(){
    [ -z "$1" ] && echo "Usage: gen_lock <script name>" && return 0
    local readonly LOCKFILE_DIR="/tmp"
    local readonly LOCK_FD=200
    local prefix="$1"
    local fd=${2:-$LOCK_FD}
    local lock_file="$LOCKFILE_DIR/$prefix.lock"

    # create lock file
    eval "exec $fd>$lock_file"

    # acquier the lock
    flock -n $fd && return 0 || return 1
}

#==============================================
# interface_info - Show info about a network interface
#
# Examples:
#   interface_info "lo" 
#   interface_info "enp4s0"
#
# @Params {String} $1: interface name
#==============================================
function interface_info(){
    [ -z "$1" ] && echo "Usage: interface_info <id interface>" && return 0

    if ifdata -e "$1"; then
        echo_pass "Interface $1 found"
        echo "=========="
        ifdata -p -ph -pf -si -so "$1"
        echo "=========="
    else
        echo_fail "No interface $1 found"
        return 0
    fi
}

#==============================================
# dtranslate - On-line translation
#
# Examples:
#   dtranslate 
#==============================================
function dtranslate(){
    PS3="${_cl_blue}Select the dictionary: ${_cl_reset}"
    local _options="por-eng eng-por por-fra fra-por por-ita ita-por por-nld nld-por por-deu deu-por tur-por lat-por jpn-por afr-por gla-por exit"
    local w=""

    select i in $_options; do
        [ $i == "exit" ] && return 0
        printf "${_cl_blue}Enter the word to translate: ${_cl_reset}"
        read w
        echo "Searching..."
        curl dict://dict.org/d:${w}:fd-${i} 2> /dev/null | grep -Ev "html|head|body|h1|hr|center|100|150|220|221|250|251|\%|Dload|\-"
    done
}

#==============================================
# mostused - Most used Commands
#
# Examples:
#   mostused 
#==============================================
function mostused(){
    cat $HISTFILE | grep -Ev "^#" | awk '{ print $1 }' | grep -Ev '^`' | grep -Ev ' ' |
    sort |
    uniq -c |
    sort -n -k1 |
    tail -25 |
    tac
}

#==============================================
# cd - cd helper
#
# Examples:
#   cd 
#   cd /bin
# 
# @Params {String} $1: directory name
#==============================================
function cd(){
    { [ -z "$1" ] && builtin cd "$HOME";           } || \
    { [ -d "$1" ] && builtin cd "$1";              } || \
    { [ -f "$1" ] && builtin cd "$(dirname "$1")"; } || \
    builtin cd "$1"
}

#==============================================
# MIT - use like this in a directory with code you want MIT-licensed: MIT > LICENSE
#
# Examples:
#   MIT
#==============================================
function MIT(){
cat <<EOF
(The MIT License)

Copyright (c) $(date +"%Y")  $USER <user@email.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF
}

#==============================================
# at_line_no - Show line, optionally show surrounding lines
#
# Examples:
#   at_line_no 1 2
# 
# @Params {String} $1: line number
# @Params {String} $2: lines around (default 0)
#==============================================
function at_line_no(){
    local lnr=$1
    local around=${2:-0}
    [ $around -ge $lnr ] && local s=1 || local s=$(expr $lnr - $around)
    echo "From line $s to line $(expr $lnr + $around)"
    sed -n "$s,$(expr $lnr + $around)p"
}

#==============================================
# meteo - Weather from wttr
#
# Examples:
#   meteo
#==============================================
function meteo(){
    local LOCLANG=$(echo ${LANG:-en} | cut -c1-2)
    clear
    if [ $# -eq 0 ]; then
        local LOCATION=$(curl -s ipinfo.io/loc)
    else
        local LOCATION=$1
    fi
    curl -s "$LOCLANG.wttr.in/$LOCATION"
}

#==============================================
# escape - UTF-8-encode a string of Unicode symbols
#
# Examples:
#   escape "\u02BBUtthay\u0101n h\u01E3ng"
#   escape "test"
# 
# @Params {String} $1: text to encode
#==============================================
function escape(){
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

#==============================================
# argc - Args counting (avoid options starting with -)
#
# Examples:
#    argc "$@"
#    argc "a" "b" "c"
#    cat argfile | argc
#    argc < argfile
# 
# @Params {String} $@: args
#==============================================
function argc(){
    local count=0;
    if [ -t 0 ]; then 
        for arg in "$@"; do
            if [[ ! "$arg" =~ '-' ]]; then
                count=$(($count+1));
            fi;
        done;
    else
        if test -p /dev/stdin || test -s /dev/stdin ; then
            for arg in $(cat /dev/stdin); do
                if [[ ! "$arg" =~ '-' ]]; then
                    count=$(($count+1));
                fi;
            done;
        fi
    fi
    echo $count;
}

#==============================================
# edit - Edit a file normally, or as root
#
# Examples:
#    edit "README"
# 
# @Params {String} $1: filename  
# @Params {String} $2: arg1
# @Params {String} $..: argn
#==============================================
function edit(){
    [ -z "$EDITOR" ] &&  EDITOR="nano"
    if [ -z "$1" ]; then
        $EDITOR "$@";
    elif [ ! -f "$1" ] || [ -w "$1" ]; then
        $EDITOR "$@";
    else
        echo -n "File is Read-only. Edit as root? (Y/n): "
        read -n 1 yn;
        echo;
        if [ "$yn" = 'n' ] || [ "$yn" = 'N' ]; then
            $EDITOR "$@";
        else
            sudo $EDITOR "$@";
        fi
    fi
}

#==============================================
# du_full - Disk usage (DU) full info
#
# Examples:
#   du_full 
#   du_full "/home"
# 
# @Params {String} $1: dirname  (optional)
#==============================================
function du_full(){
    [ -z "$1" ] && local d="$(pwd)" || local d="$1"
    df -h "$d" | awk 'NR==2 { print $1" - Total:"$2", Used:"$3", Free:"$4", Use%:"$5 }'
}

#==============================================
# du_short - Disk usage (DU) partial info
#
# Examples:
#   du_short 
#   du_short "/home"
# 
# @Params {String} $1: dirname  (optional)
#==============================================
function du_short(){
    [ -z "$1" ] && local d="$(pwd)" || local d="$1"
    df -h "$d" | awk 'NR==2 { print $1":"$5 }'
}

#==============================================
# hosts_up - Active hosts on your LAN
#
# Examples:
#   hosts_up 
#==============================================
function hosts_up(){
    local ip_local=$(ip -br -h -4 address | grep "UP" | awk '/UP/{print $3}' | sed -e 's/\/24//g')
    local ip_neig=$(ip -br -h -4 neigh | awk '/dev/{print $1}')
    local sor_ips=$(echo -e "$ip_local\n$ip_neig" | sort)
    echo "$sor_ips"
}

#==============================================
# screens_count - Count active screens. (Doesn't catch named sessions, need to update)
#
# Examples:
#   screens_count 
#==============================================
function screens_count(){
    local scpth="/var/run/screen/S-$USER"
    if [ -e "$scpth" ]; then
        if [ -n "$(find $scpth -prune -empty)" ]; then
            echo "0"
        else
            echo $(screen -ls | egrep -c "[0-9]+\.([a-zA-Z0-9\-]+)?\.[a-zA-Z]*")
        fi
    else
        echo  "0"
    fi
}

#==============================================
# screens_and_jobs_count - Count Active Screen and Jobs
#
# Examples:
#   screens_and_jobs_count 
#==============================================
function screens_and_jobs_count(){
    local all_screens=$(screens_count)
    local all_jobs=$(jobs_count)
    [ 0 -lt $all_screens ] && [ 0 -lt $all_jobs ] && echo -n "$all_screens Scr|$all_jobs Jobs|" && return
    [ 0 -lt $all_screens ] && [ 0 -eq $all_jobs ] && echo -n "$all_screens Scr|" && return
    [ 0 -eq $all_screens ] && [ 0 -lt $all_jobs ] && echo -n "$all_jobs Jobs|" && return
    echo -n "" && return
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

#==============================================
# Show process name of a PID
#==============================================
function process_name(){
    [ -z "$1" ] && echo "Usage: process_name <PID>" && return 1
    ps -p $1 -o comm=
    if [ $? != 0 ]; then
        echo ""
    fi
}

#==============================================
# Extract files 
#==============================================
function do_extract(){
    if [ -z "$1" ]; then
        echo "Usage: do_extract <path/filename>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        local f=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        if [ -f $1 ] ; then
            case $f in
                *.tar.bz2)   tar xvjf ./$1    ;;
                *.tar.gz)    tar xvzf ./$1    ;;
                *.tar.xz)    tar xvJf ./$1    ;;
                *.lzma)      unlzma ./$1      ;;
                *.bz2)       bunzip2 ./$1     ;;
                *.rar)       unrar x -ad ./$1 ;;
                *.gz)        gunzip ./$1      ;;
                *.tar)       tar xvf ./$1     ;;
                *.tbz2)      tar xvjf ./$1    ;;
                *.tgz)       tar xvzf ./$1    ;;
                *.zip)       unzip ./$1       ;;
                *.Z)         uncompress ./$1  ;;
                *.7z)        7z x ./$1        ;;
                *.xz)        unxz ./$1        ;;
                *.exe)       cabextract ./$1  ;;
                *)           echo_fail "do_extract: '$1' - método de compactação desconhecido" ;;
            esac
        else
            echo_fail "$1 - file do not exist"
        fi
    fi
}

#==============================================
# Retrieve pending e-mails quantity
#==============================================
function qt_mail(){
    local f="/var/mail/$USER"
    if [ -e "$f" ]; then
        awk '/From:/{print $0}' $f | grep -c "From:"
    else
        echo "0"
    fi
}

#==============================================
# Msg you have mail
#==============================================
function you_have_mail(){
    local nQtMail=$(qt_mail)
    if  [[ $nQtMail -gt 0 ]]; then
        [ "$(echo ${LANG:-en} | cut -c1-2 )" = "pt" ] && echo "Voce tem $nQtMail novo(s) e-mail(s)!" || echo "You have $nQtMail unread mail(s)!"
    fi
}

#==============================================
# String for Git repos status
#==============================================
function prompt_git(){
    local s="";
    local branchName="";
    # Check if the current directory is in a Git repository.
    if git branch &>/dev/null; then
        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null;
            # Check for uncommitted changes in the index.
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s+='+';
            fi;
            # Check for unstaged changes.
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s+='!';
            fi;
            # Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+='?';
            fi;
            # Check for stashed files.
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s+='$';
            fi;
        fi;

        # Get the short symbolic ref.
        # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
        # Otherwise, just give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null || echo '(unknown)')";

        [ -n "${s}" ] && s="[${s}]";

        #echo -e "${1}${branchName}${2}${s}";
        echo "${1}${branchName}${2}${s} ";
    else
        echo ""
    fi;
    return 0;
}

#==============================================
# A bash_prompt function
#==============================================
function bash_prompt(){
    local git_b_str=""
    local git_prompt=""
    # Checks to see if the current directory is a git repo or not
    if git branch &>/dev/null; then
        git_b_str=" "$(prompt_git);
        # If we are in a git repo, then check to see if there are uncommitted files
        if LC_ALL=C git status | grep "nothing to commit" > /dev/null 2>&1; then
            # If there are no uncommitted files, then set the color of the git branch name to green
            git_prompt="$BG$git_b_str";
        else
            # If there are uncommitted files, set it to red.
            git_prompt="$BR$git_b_str";
        fi
    else
        # If we're not in a git repo, then display nothing
        git_prompt=""
    fi
    local sQtma=$(if [ $(qt_mail) -eq 0 ]; then echo ""; else echo "$BG✉ "; fi)
    PS1="\$(if [[ \$? == 0 ]]; then echo \"$BG✔\"; else echo \"$BR✘\"; fi) ${sQtma}$BW${debian_chroot:+($debian_chroot)}\u@\h $NONE$BY[\w]$NONE\n$BW  └${git_prompt}$BW─$BG[\A]$BW>$BR \\$ $NONE"
    PS2="\$(echo \"$BG✔\") $NONE"
    PS3=": "
    PS4='$0.$LINENO+ '
    RPS1="\$(echo \"$BG✔\")\w $NONE"
}

#==============================================
# Uptime em portugues/ingles
#==============================================
function uptime_active(){
    local Utmc=$(uptime -p | tr -d ',' | tr -s ' ' | sed -e 's/up //g')
    local hasY=$(echo "$Utmc" | grep -o 'year' | wc -l  || echo -n "0")
    local hasM=$(echo "$Utmc" | grep -o 'month' | wc -l  || echo -n "0")
    local hasW=$(echo "$Utmc" | grep -o 'week' | wc -l || echo -n "0")
    local hasD=$(echo "$Utmc" | grep -o 'day' | wc -l || echo -n "0")
    local hasH=$(echo "$Utmc" | grep -o 'hour' | wc -l || echo -n "0")

    if [ "$hasY" == "1" ]; then
        Utmc=$(echo "$Utmc" | sed -e 's/year /year, /g' -e 's/years/years,/g')
    fi
    if [ "$hasM" == "1" ]; then
        Utmc=$(echo "$Utmc" | sed -e 's/month /month, /g' -e 's/months/months,/g')
    fi
    if [ "$hasW" == "1" ]; then
        Utmc=$(echo "$Utmc" | sed -e 's/week /week, /g' -e 's/weeks/weeks,/g')
    fi
    if [ "$hasD" == "1" ]; then
        Utmc=$(echo "$Utmc" | sed -e 's/day /day, /g' -e 's/days/days,/g')
    fi
    if [ "$hasH" == "1" ]; then
        Utmc=$(echo "$Utmc" | sed -e 's/hour /hour e /g' -e 's/hours/hours e/g')
    fi
    if [ "$(echo $LANG | cut -c1-2)" = "pt" ]; then
        Utmc=$(echo "$Utmc" | sed -e 's/year/ano/g' -e 's/month /mes /g' -e 's/months/meses/g' -e 's/week/semana/g' -e 's/day/dia/g' -e 's/hour/hora/g' -e 's/minute/minuto/g')
    fi
    echo "$Utmc"
}

#==============================================
# zsh-like RPROMPT composition function for bash
#==============================================
function __rprompt(){
    # rprompt strings
    local sDirc=$(_dir_count)
    sDirc=${sDirc}
    local sArqc=$(_file_count)
    sArqc=${sArqc}
    local sTota=$(_pwd_size)
    sTota=${sTota}
    local ScrJob=$(screens_and_jobs_count)
    ScrJob=${ScrJob}
    local DuSho=$(du_short)
    DuSho=${DuSho}
    # terminal columns
    local nCols=$(tput cols)
    # left side prompt strings length
    local stPwd=$(echo "$(dirs +0)")
    local nPwdlen=$(strLen $stPwd)
    local nUsrlen=$(strLen $USER)
    local nHstlen=$(strLen $HOSTNAME)
    local nQtm=$(qt_mail)
    # two more chars to count
    if [[ $nQtm -gt 0 ]]; then
        let nQtm=2
    fi
    local nTotLen=0
    # Colors and attrs
    tput bold
    tput setaf 3
    # rprompt info
    stPpt=$(echo "$RPROMPT [${ScrJob}${sDirc} Dirs|${sArqc} Arqs|${sTota}b] ${DuSho}")
    # rprompt string length
    nPptlen=${#stPpt}
    # total prompt string length
    let nTotLen=nPwdlen+nPptlen+nUsrlen+nHstlen+nQtm+9
    # display control (based on terminal columns)
    if [[ $nTotLen -gt $nCols ]]; then
        echo  "$stPpt"
    else
        printf "%*s\r" "$COLUMNS" "$(echo -e "$stPpt")"
    fi
    # Reset colors
    tput sgr0
}

#==============================================
# progress bar
#==============================================
function draw(){
    local perc=$1
    local size=$2
    local inc=$(( perc * size / 100 ))
    local out=
    if [ -z "$3" ]; then
        local color="36"
    else
        local color="$3"
    fi
    for v in $(seq 0 $(( size - 1 ))); do
        test "$v" -le "$inc" && out="${out}\e[1;${color}m${FULL}" || out="${out}\e[0;${color}m${EMPTY}"
    done 
    printf $out
}

#==============================================
# color bar
#==============================================
function color_bar(){
    printf "\n"
    local i=0
    while [ $i -le 6 ]; do
        printf "\e[$((i+41))m\e[$((i+30))m█▓▒░"
        i=$(($i+1))
    done
    printf "\e[37m█\e[0m▒░\n\n"
}

#==============================================
# find wm (window manager)
#==============================================
function find_wm(){
    local wm=""
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        wm="$XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
        wm="$DESKTOP_SESSION"
    else
        wm="$(ps -e | grep -i "^.*wm\|i3\|awesome\|sway\|openbox\|blackbox\|fluxbox" | awk 'NR == 1 {print $4}')"
    fi
    if [ -z "$wm" ] && [ $(command -v xprop 2> /dev/null | grep -c "xprop" ) -ge 1 ]; then
        local id="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK 2> /dev/null | grep "id" | awk '{print $5}')"
        [ -n "$id" ] && wm="$(xprop -id "0xa0009b" -notype -len 100 -f _NET_WM_NAME 8t | grep "_NET_WM_NAME" | awk '{gsub(/"/, "", $3); print $3 }')"
    fi
    echo "$wm"
    return 0
}

#==============================================
# Greetings (A kind of fetch info display)
#==============================================
function greetings(){
    local USR="$(whoami)"
    local DIST="$(~/bin/distro-info -1 | ~/bin/capitalize)"
    local KERNEL="$(uname -rmo)"
    local TIMEU="$(uptime_active)"
    local TIMEDe="$(uptime_since)"
    local FrMEM="$(free_mem)"
    local TtMEM="$(total_mem)"
    local AvMEM="$(avail_mem)"
    local BVERS="$BASH_VERSION"
    local BASELANG=$(echo "$LANG" | awk -F'.' '{ print $1 }')
    local BASELOC=$(echo "$LANG" | cut -c1-2)
    local FULL=━
    #local FULL=┅
    local EMPTY=┄
    #local EMPTY=━
    #local EMPTY=─

    if [ "$BASELOC" = "pt" ]; then
        local DATE="$(date +"%d/%m/%Y")"
    elif [ "$BASELOC" = "en" ]; then
        local DATE="$(date +"%m/%d/%Y")"
    else
        local DATE="$(date +"%Y/%m/%d")"
    fi

    cls

    if [ "$BASELOC" = "pt" ]; then
        printf " \e[1;33mOlá, seja bem vindo. $(you_have_mail)\e[0m\n\n"
        printf " \e[1;36mStatus do Sistema em $DATE:\e[0m\n"
    else
        printf " \e[1;33mHi, Welcome. $(you_have_mail)\e[0m\n\n"
        printf " \e[1;36mSystem Status at $DATE:\e[0m\n"
    fi

    printf " \e[1;36m     distro  $DIST@ kernel $KERNEL\e[0m\n"

    if [ "$BASELOC" = "pt" ]; then
        printf " \e[1;36m     uptime  $TIMEU desde $TIMEDe\e[0m\n"
    else
        printf " \e[1;36m     uptime  $TIMEU since $TIMEDe\e[0m\n"
    fi
    
    if xset q &>/dev/null ; then
        local wm="$(find_wm)"
        printf " \e[1;36m      shell  $BVERS @ $wm\e[0m\n"
    else
        printf " \e[1;36m      shell  $BVERS\e[0m\n"
    fi

    # cpu
    if [ "$BASELOC" = "pt" ]; then
        local CpuUsg=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | sed "s/\./,/g")
    else
        local CpuUsg=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
    fi

    local CpuLvl=$(printf "%.0f" $CpuUsg)
    [ -n "$CpuLvl" ] && printf "   \e[0;36m%-4s \e[1;36m%-5s %-25s \n" " cpu" "$CpuLvl%" $(draw $CpuLvl 15)

    # ram
    local RamM=$(free | awk '/Mem/ {print int($3/$2 * 100.0)}')
    [ -n "$RamM" ] &&  printf "   \e[0;36m%-4s \e[1;36m%-5s %-25s \n" " ram" "$RamM%" $(draw $RamM 15)

    # battery
    local charge="$(battery_percentage 2> /dev/null)"
    if [ -n "$charge" ] && [ "$charge" != "no" ]; then
        case 1 in
            $(($charge <= 15)))
                local color='31'
            ;;
            *)
                local color='36'
            ;;
        esac
        printf "   \e[0;${color}m%-4s \e[1;${color}m%-5s %-25s \n" " bat" "$charge%" $(draw $charge 15 $color)
    fi

    # volume
    # test amixer return first
    amixer get Master &>/dev/null
    if [ $? -eq 0 ]; then 
        if amixer get Master | grep -q 'Right'; then
            local vol=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | tr -d '[]%')
        else
            local vol=$(awk -F"[][]" '/%/ { print $2 }' <(amixer sget Master)  | tr -d '[]%')
        fi
        if amixer get Master | grep -q '\[off\]'; then
            local color='31'
        else
            local color='36'
        fi
        [ -n "$vol" ] && printf "   \e[0;${color}m%-4s \e[1;${color}m%-5s %-25s \n" " vol" "$vol%" $(draw $vol 15 $color)
    fi
    
    # temperature
    if sensors &>/dev/null; then
        local SensTemp=$(sensors | awk '/Core 0/ {gsub(/\+/,"",$3); gsub(/\..+/,"",$3)    ; print $3}')
        if [ -n "$SensTemp" ]; then
            case 1 in
                $(($SensTemp <= 50)))
                    color='34'
                ;;
                $(($SensTemp >= 75)))
                    color='31'
                ;;
                *)
                    color='36'
                ;;
            esac
            printf "   \e[0;${color}m%-4s \e[1;${color}m%-5s %-25s \n" "temp" "$SensTemp˚C " $(draw $SensTemp 15 $color)
        fi
    fi
    printf "\e[1;33m\n"

    ~/bin/my-motd

    echo -e "\n"
    #echo -e "$(you_have_mail)\n"
    # Reset colors
    tput sgr0
    #color_bar
}
