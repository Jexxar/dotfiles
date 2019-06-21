# 'custom' functions

#==============================================
# Oneliners
#==============================================
# Xargs com function. Ex. echo "abc" | do_xarg echo_pass
function do_xarg() { local funnm=$1; xargs -I{} bash -c "$funnm"\ \{\}; }
# Logical test functions
function is_empty() { local var=$1;  [[ -z $var ]] ; }
function is_not_empty() { local var=$1;  [[ -n $var ]] ;}
function is_file() { local file=$1;  [[ -f $file ]] ; }
function is_dir() { local dir=$1;  [[ -d $dir ]]; }
# Random passw. ex: rpass 6
function rpass() { cat /dev/urandom | tr -cd '[:graph:]' | head -c ${1:-12}; }
# Return system load as percentage, i.e., '40' rather than '0.40)'.
function sys_load() { local SYSLOAD=$(cut -d " " -f1 /proc/loadavg | tr -d '.');  echo $((10#$SYSLOAD)) ; }
# Crypt file using ascii armor
function aencrypt () {  gpg -ac --no-options "$1" ; }
# Crypt binary file. jpegs/gifs/vobs/etc.
function bencrypt () { gpg -c --no-options "$1" ; }
# Drcrypt (with no options)
function decrypt () { gpg --no-options "$1" ; }
# Number of CPUs
function ncpu() { grep -c 'processor' /proc/cpuinfo ; }
# Custom ps my user processes
function my_ps() { ps "$@" -u "$USER" -o pid,%cpu,%mem,bsdtime,command ; }
# Custom my user processes tree
function psgrep() { my_ps f | awk '!/awk/ && $0~var' var="${1:-".*"}" ; }
# Submit a job
function sub() { ($1 &) ;}
# Goto dir
function goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }
# Copy and Goto dir
function cpf() { cp "$@" && goto "$_"; }
# Move and Goto dir
function mvf() { mv "$@" && goto "$_"; }
# Mkdir and Goto dir
function mkf() { mkdir -p "$1" && goto "$1"; }
# Test if a such command exists
function cmd_exists() { command -v "$1" &> /dev/null; }
# Top used cmds
function top_cmds() { grep -Ev '^#' "$HISTFILE" | awk '{ print $1 }' | grep -Ev '^`' | grep -Ev ' ' | sort | uniq -c | sort  -n -k1 | sort -rn | head ; }
# Color tree of current dir
function lsr() { tree -ChvugapfF --dirsfirst | most -ct4 +82 +s ; }
# Reset terminal
function cls() { printf "%b" "\ec"; }
# Decode base64
function decode_64 () { echo "$@" | base64 -d ; }
# Encode base64
function encode_64 () {  echo "$@" | base64 - ; }
# DICTIONARY FUNCTIONS
function dwordnet () { curl dict://dict.org/d:"${1}":wn; }
function dacron () { curl dict://dict.org/d:"${1}":vera; }
function djargon () { curl dict://dict.org/d:"${1}":jargon; }
function dfoldoc () { curl dict://dict.org/d:"${1}":foldoc; }
function dthesaurus () { curl dict://dict.org/d:"${1}":moby-thes; }
# Hour (24 h format)
function hora () { date -Ins | cut -b 12-19 ; }
# Date ISO format
function dataiso () { date -Ins | cut -b 1-10 ; }
# Data (european format)
function data () { date +"%d-%m-%Y" ; }
# Date n days ago
function yday() { local dstr="date --date='-$1 day'";  eval "$dstr"; }
# Date +n dias ahead
function tday() { local dstr="date --date='+$1 day'";  eval "$dstr"; }
# Grep enhance
function bro-grep() { grep -E "(^#)|$1" "$2"; }
# Grep enhance zip files
function bro-zgrep() { zgrep -E "(^#)|$1" "$2"; }
# Search javascripts files for
function jsgrep() { find . \( -name "*.js" -print \)  | xargs grep -in "$1" ; }
# Search development css files
function cssgrep() { find . \( -name "*.css" -print \)  | xargs grep -in "$1"; }
# Search php files
function phpgrep() { find . \( -name "*.php" -print \)  | xargs grep -in "$1"; }
# Search html files
function htmgrep() { find . \( -name "*.html" -print \)  | xargs grep -in "$1"; }
# Search php files and development scripts/styles
function wdevgrep() { find . \( -name "*.php" -print -or -name "*.js" -or -name "*.css" -print \)  | xargs grep -n "$1"; }
# Top count lines
function topcount() { sort | uniq -c | sort -rn | head -n "${1:-10}"; }
# Most color
function mostcolor() { cat "$1" | sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[%sm %s \x1b[0m",(i%7)+31,$i);print ""}' | most -RS; }
# Uptime since
function uptime_since() { uptime -ps ; }
# Free memory
function free_mem() { awk '/MemFree/{print $2"M"}' /proc/meminfo ; }
# Total memory
function total_mem() { awk '/MemTotal/{print $2"M"}' /proc/meminfo ; }
# Available memory
function avail_mem() { awk '/MemAvailable/{print $2"M"}' /proc/meminfo ; }
# Fuzzy find file
function ff() {  find . -type f -iname "$*";}
# Find a file with a pattern in name:
function fff() { find . -type f -iname '*'"$*"'*';}
# Fuzzy find dir
function fd() {  find . -type d -iname "$*";}
# Find a dir with a pattern in name:
function fdf() { find . -type d -iname '*'"$*"'*';}
# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'"${1:-}"'*' -exec "${2:-file}" {} \;  ; }
# Number of active jobs
function jobs_count() { jobs -r | wc -l | sed -e "s/ //g" ; }
# Number of stopped jobs
function stoppedjobs() { jobs -s | wc -l | sed -e "s/ //g" ; }
# Laptop battery %
function laptop_battery() { upower -i "$(upower -e | grep 'BAT')" | grep -E "state|to\ full|percentage" ; }
# Mouse battery %
function mouse_battery() { upower -i "$(upower -e | grep 'mouse')" | grep -E "state|to\ full|percentage" ; }
# Back n dirs
function up() { cd $(eval printf '../'%.0s {1..$1}) ; }
# Simple backup
function bak() { cp "$1" "$1_$(date +%Y-%m-%d_%H:%M:%S).bak" ; }
# Generate space report
function space() { du -skh * | sort -hr ; }
# Processor info
function core() { cat /proc/cpuinfo | grep "model name" | cut -c14- ; }
# Graphic card
function graph() { lspci | grep -i vga | cut -d: -f3 ; }
# Ethernet card
function ethcard() { lspci | grep -i ethernet | cut -d: -f3 ; }
# Wireless card
function wfcard() { lspci | grep -i network | cut -d: -f3 ; }
# Display on a desired color (ex: red $1)
function onblack() { echo "$(tput setaf 0)$*$(tput sgr0)"; }
function onred() { echo "$(tput setaf 1)$*$(tput sgr0)"; }
function ongreen() { echo "$(tput setaf 2)$*$(tput sgr0)"; }
function onyellow() { echo "$(tput setaf 3)$*$(tput sgr0)"; }
function onblue() { echo "$(tput setaf 4)$*$(tput sgr0)"; }
function onmagenta() { echo "$(tput setaf 5)$*$(tput sgr0)"; }
function oncyan() { echo "$(tput setaf 6)$*$(tput sgr0)"; }
function onwhite() { echo "$(tput setaf 7)$*$(tput sgr0)"; }
# Display on a desired via pipe (ex: cmd1 | on_green)
function on_black() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;30m %s \x1b[0m",$i);print ""}'; }
function on_red() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;31m %s \x1b[0m",$i);print ""}'; }
function on_green() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;32m %s \x1b[0m",$i);print ""}'; }
function on_yellow() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;33m %s \x1b[0m",$i);print ""}'; }
function on_blue() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;34m %s \x1b[0m",$i);print ""}'; }
function on_magenta() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;35m %s \x1b[0m",$i);print ""}'; }
function on_cyan() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;36m %s \x1b[0m",$i);print ""}'; }
function on_white() { sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[0;37m %s \x1b[0m",$i);print ""}'; }
# Commandline FU MOTD
function cm_fu_motd () { curl http://www.commandlinefu.com/commands/random/plaintext -o "$HOME"/.motd -s -L && cgre "$HOME"/.motd ; }
# Command line Calculations
function calc() { printf '%s\n' "scale=3;${*//[ ]}" | bc -l ; }
# Run `dig` and display the most useful info
function digga() { dig +nocmd "$1" any +multiline +noall +answer; }
# tre is a shorthand for tree with hidden files and color enabled, ignoring `.git` directory, listing directories first.
function tre() { tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | most -FRNX; }
# Pre append a path to the PATH
function prepend-path() { [ -d "$1" ] && PATH="$1:$PATH" ; }
# Show duplicate/unique lines
function duplines() { sort "$1" | uniq -d ; }
# Show unique lines
function uniqlines() { sort "$1" | uniq -u ; }
# Get IP from hostname
function hostname2ip() { ping -c 1 "$1" | egrep -m1 -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' ; }
# Logging stuff. header
function e_header() { printf "\n${_cl_bold}${_cl_purple}===  %s  ===${_cl_reset}\n" "$@" ; }
# Logging stuff. arrow
function e_arrow() { printf "➜ %s\n" "$@" ; }
# Logging stuff. Success
function e_success() { printf "${_cl_green}✔ %s${_cl_reset}\n" "$@" ; }
# Logging stuff. Error
function e_error() { printf "${_cl_red}✖ %s${_cl_reset}\n" "$@" ; }
# Logging stuff. Warning
function e_warning() { printf "${_cl_yellow}➜ %s${_cl_reset}\n" "$@" ; }
# Logging stuff. Underline text
function e_underline() { printf "${_cl_underline}$_cl_{bold}%s${_cl_reset}\n" "$@"; }
# Logging stuff. Bold
function e_bold() { printf "${_cl_bold}%s${_cl_reset}\n" "$@"; }
# Logging stuff. Note in blue
function e_note() { printf "${_cl_underline}${_cl_bold}${_cl_blue}Note:${_cl_reset}  ${_cl_blue}%s${_cl_reset}\n" "$@"; }
# Logging stuff. List item
function e_itemok() { echo -e " \033[1;32m✔\033[0m  $@"; }
# Logging stuff. Error list item
function e_itemnok() { echo -e " \033[1;31m✖\033[0m  $@"; }
# Logging stuff. Arrow item
function e_itemarrow() { echo -e " \033[1;34m➜\033[0m  $@"; }
# Echo assertion fail
function echo_fail() { printf "%s \e[31m[✘] " "$@";  echo -e "\033[0m" ; }
# Echo assertion pass
function echo_pass() { printf "%s \e[32m[✔] " "$@";  echo -e "\033[0m"; }
# Appends your key to a server's authorized keys file
function authme() { ssh "$1" 'cat >>.ssh/authorized_keys' <~/.ssh/id_rsa.pub ; }
# Web helper get
function couch-get() { curl -s -X GET "$@" 2>&1 ; }
# Web helper put
function couch-put() { curl -s -X PUT "$@" 2>&1 ; }
# Web helper post
function couch-post() { curl -s -X POST "$@" 2>&1 ; }
# Web helper delete
function couch-delete() { curl -s -X DELETE "$@" 2>&1 ; }
# Hexadecimal conversion
function decimal2hex() { echo 16o "$1" p | dc ; }
# Rsync simple backup
function rsync_bpk() { rsync "$1" -rvhzI --size-only --inplace --human-readable --compress --compress-level=1 "$2" ; }
# Dir count
function _dir_count() { /bin/ls -lagFXh1 | grep '/' | awk '!/\.\./' | awk '!/\.\//' | /usr/bin/wc -l | /bin/sed 's: ::g' ; }
# File count
function _file_count() { /bin/ls -lagFXh1 | grep '\-rw' | /usr/bin/wc -l | /bin/sed 's: ::g' ;  }
# Current pwd_dir size
function _pwd_size() { /bin/ls -lagFXh1 | /bin/grep -m 1 total | /bin/sed 's/total //' ; }
# Commit and push everything
function gitdone() { git add -A; git commit -S -v -m "$1"; git push; }

#==============================================
# strip_all - Strip a pattern from a string.
#
# Examples:
#    strip_all "The Quick Brown Fox" "[aeiou]"
#
# @param {String} $1  string 
# @param {String} $2  string pattern inside
#==============================================
strip_all() {
    printf '%s\n' "${1//$2}"
}

#==============================================
# qh - Search bash history for a command.
#
# Examples:
#    qh ls 
#
# @param {String} $*  search string
#==============================================
function qh() {
    if cmd_exists "hstr"; then
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
function qtxt() {
    #     ┌─ ignore case
    #     │┌── search all files under each directory, recursively
    grep -ir --color=always "$*" --exclude-dir=".git" --exclude-dir="node_modules" . | less -RXS#3M~g
    #       display ANSI color escape sequences in raw form ─────────────────────────────────┘│
    #           don't clear the screen after quitting less ───────────────────────────────────┘
}

#==============================================
# _mkdir - Make a dir with a default permission
#
# Examples:
#    _mkdir test 
#    _mkdir test 0644
#
# @param {String} $1  dir name 
# @param {String} $2  permission mask 
#==============================================
function _mkdir() {
  local d="$1"            # get dir name
  local p=${2:-0755}      # get permission, set default to 0755
  [ $# -eq 0 ] && { echo "$0: dirname"; return; }
  [ ! -d "$d" ] && mkdir -m "$p" -p "$d"
}

#==============================================
# position_cursor - Set cursor positon to a fixed location
#
# Examples:
#    position_cursor
#==============================================
function position_cursor () {
    local RES_COL
    let RES_COL=`tput cols`-12
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
function display_status () {
    local STATUS="$1"
    local STATUS_COLOUR

    case $STATUS in
    OK | ok | Ok )
            STATUS="   OK    "
            STATUS_COLOUR="$_cl_green"
            ;;
    PASSED | passed | Passed )
            STATUS=" PASSED  "
            STATUS_COLOUR="$_cl_green"
            ;;
    SUCCESS | SUCCESS | success | Success )
            STATUS=" SUCCESS "
            STATUS_COLOUR="$_cl_green"
            ;;

    FAILURE | failure | Failure | FAILED | failed | Failed | ERROR | error | Error )
            STATUS=" FAILURE "
            STATUS_COLOUR="$_cl_red"
            ;;
    INFO | info | Info | NOTICE | notice | Notice )
            STATUS=" NOTICE  "
            STATUS_COLOUR="$_cl_blue"
            ;;
    WARNING | Warning | warning | WARN | warn )
            STATUS=" WARNING "
            STATUS_COLOUR="$_cl_yellow"
            ;;
    esac

    position_cursor
    echo "[$_cl_bold$STATUS_COLOUR$STATUS$_cl_reset]"
}

#==============================================
# is_installed - Verify if such a package exists
#
# Examples:
#    is_installed firefox
#
# @param {String} $1  package name 
#==============================================
function is_installed() {
  dpkg -s "$1" &> /dev/null

  if [ $? -eq 0 ]; then
      echo_pass "Package $1 is installed!"
      return 0
  else
      echo_fail "Package $1 is NOT installed!"
      return 1
  fi
}

#==============================================
# ip_inf - Shows detailed IP info about a host
#
# Examples:
#    ip_inf google.com
#
# @param {String} $1  URL to inspect
#==============================================
function ip_inf() {
    if grep -P "(([1-9]\d{0,2})\.){3}(?2)" <<< "$1"; then
        curl ipinfo.io/"$1"
    else
        local ipawk=($(host "$1" | awk '/address/ { print $NF }'));
        curl ipinfo.io/"${ipawk[0]}"
    fi
    echo
}

#==============================================
# xfind - Will print out the files and the lines that contain the pattern
#
# Examples:
#    xfind path pattern
#
# @param {String} $1  path
# @param {String} $2  pattern to search for
#==============================================
function xfind() {
    local FIND_VAR="$2";
    local STACK="$1";
    if [ -f "$STACK" ] || [ -d "$STACK" ]; then
        find "$STACK" \
            -exec grep --color "$FIND_VAR" -sl '{}' \; \
            -exec grep "$FIND_VAR" -s '{}' \;
    else
        echo_fail "ERROR: No file or folder with the name '$STACK' exist";
    fi
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
function is_newer() {
     if [ $# -ne 2 ]; then
          echo "Usage: is_newer file1 file2" 1>&2
          return 1
     fi

     if [ ! -f "$1" -o ! -f "$2" ]; then
          return 1       # No
     fi

     if [ -n "`find "$1" -newer "$2" -print`" ]; then
          return 0       # Yes
     else
          return 1       # No
     fi
}

#==============================================
# is_systype - compare string with current system and return true (0) if it matches uname command
#
# Examples:
#   is_systype "Linux"
#
# @param {String} $1  SystemType string
#==============================================
function is_systype() {
     if [ -z "$1" ] ; then
          echo "Usage: is_systype <string>"
          return 1
     fi

     if [ "$1" = "`uname -s`" ]; then
          return 0
     elif [ "$1" = "`uname -m`" ]; then
          return 0
     else
          case `uname -r` in
               "$1"* ) return 0 ;;
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
function is_alpha() {
    if [ -z "$1" ] ; then
        echo "Usage: is_alpha <string>"
        return 1
    fi
    local i="$1"
    local c=$(echo "$1" | sed -e 's/[^[:alnum:]]//g')

    if [ "$c" != "$i" ] ; then
        return 1
    else
        return 0
    fi
}

#==============================================
# is_int - Ensures that input only consists of numeric characters and initial sign.
#
# Examples:
#   is_int "001"
#
# @param {String} $1 string
#==============================================
function is_int() {
    local number="$1";
    local testvalue="";

    if [ -z "$number" ] ; then
        echo "Usage: is_int <string>"
        return 1
    fi

    if [ "${number%${number#?}}" == "-" ] ; then   # first char '-' ?
        testvalue="${number#?}"     # all but first character
    else
        testvalue="$number"
    fi

    if [ -z "$testvalue" ] ; then
        return 1
    fi

    local nodigits=$(echo "$testvalue" | sed 's/[[:digit:]]//g')

    if [ ! -z "$nodigits" ] ; then
      return 1
    fi
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
function is_float() {
    if [ -z "$1" ] ; then
        echo "Usage: is_float <string>"
        return 1
    fi
    local fvalue="$1"
    local pt=$(echo "$fvalue" | sed 's/[^.]//g')

    if [ ! -z "$pt" ] ; then
        local decimalPart=$(echo "$fvalue" | cut -d. -f1)
        local fractionalPart=$(echo "$fvalue" | cut -d. -f2)
        if [ ! -z "$decimalPart" ] ; then
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
# cache - Cache the result of a command in a file, and
# use the file to output the results in case it exists.
#
# Examples:
#   cache "~/.cache" "ls" "-lar"...
#
# @param {String} $1 filename to cache
# @param {String} $2 command to execute
# @param {String} $3 command arg1
# @param {String} $.. command argn
#==============================================
function cache() {
    if [[ -z "$1" ]]; then
        echo "Usage: cache <basename_to_cache_in> <cmd> <arg1> <arg2> <arg3> ..."
        return 0
    fi

    local cache_fn="$1"
    shift

    local dir="${CACHE_DIR:-.}"

    if ! test -d "$dir"; then
        mkdir -p "$dir"
    fi

    local fn="$dir/$cache_fn"
    if ! test -f "$fn" ; then
        "$@" > "$fn"
    fi
    cat "$fn"
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
function serve_py() {
    local port="${1:-8000}";
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
    python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

#==============================================
# serve_php - Start a PHP server from a directory, optionally specifying the port (Requires PHP 5.4.0+.)
#
# Examples:
#   serve_php
#   serve_php 8080
#
# @param {String} $1 port number
#==============================================
function serve_php() {
    local port="${1:-4000}";
    local ip=`ipconfig getifaddr en1`;
    php -S "${ip}:${port}";
}

#==============================================
# ask_confirmation - Ask for a simple yes/no confirmation
#
# Examples:
#   ask_confirmation "Are you ready?"
#
# @param {String} $1 question string
#==============================================
function ask_confirmation() {
    printf "\n${_cl_bold}$@${_cl_reset}"
    read -p " (y/n) " -n 1
    printf "\n"
}

#==============================================
# is_confirmed - Test whether the result of an 'ask' is a confirmation
#
# Examples:
#   is_confirmed 
#==============================================
function is_confirmed() {
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      return 0
    fi
    return 1
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
function get_full_path() {
    local user_home;
    local user_home_sed;
    local rel_path;
    local result;
    user_home="${HOME//\//\\\/}";
    user_home_sed="s#~#${user_home}#g";
    rel_path=`echo "${1}" | sed "${user_home_sed}"`;
    result=`readlink -e "${rel_path}"`;
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
function exesudo () {
    if [[ $# -eq 0 ]]; then
        echo "Usage: exesudo <cmd> <arg1> <arg2> <arg3> ..."
        return 0
    fi
    local _funcname_="$1"
    local params=( "$@" )       ## array containing all params passed here
    local tmpfile=$(mktemp)     ## temporary file
    local filecontent           ## content of the temporary file
    local regex                 ## regular expression
    local func                  ## object source

    # Shift the first param (which is the name of the object)
    unset params[0]             ## remove first element
    # params=( "${params[@]}" )     ## repack array

    # bash header for TEMPORARY FILE:
    content="#!/bin/bash\n\n"

    # Write the params array
    content="${content}params=(\n"

    regex="\s+"
    for param in "${params[@]}"
    do
        if [[ "$param" =~ $regex ]]
            then
                content="${content}\t\"${param}\"\n"
            else
                content="${content}\t${param}\n"
        fi
    done

    rm -f $tmpfile
    content="$content)\n"
    echo -e "$content" > "$tmpfile"
    echo "#`type "$_funcname_" `" >> "$tmpfile"
    echo -e "\n$_funcname_ \"\${params[@]}\"\n" >> "$tmpfile"
    sudo bash "$tmpfile"
    rm -f "$tmpfile"
}

#==============================================
# servername_pull - Rsync pull from server
#
# @option -h:   help
# @option -u:   Set a remote username
# @option -s:   Set a remote hostname
#
# @param {String} $1 - path from
# @param {String} $2 - path to
#==============================================
function servername_pull() {
    function this_usage() {
        echo "Usage:  servername_pull [options] PATH_FROM PATH_TO."
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
        echo "servername_pull -u server_username -s server.address.edu.au /home/server/path/*.py ./temp"
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
    echo "#rsync -avz --progress $usr_name@$srv_name:$* "
    #rsync -avz --progress server_username@server.address.edu.au:$*
}

#==============================================
# servername_push - Rsync push to a server
#
# @option -h:   help
# @option -u:   Set a remote username
# @option -s:   Set a remote hostname
#
# @param {String} $1 - path from
# @param {String} $2 - path to
#==============================================
function servername_push() {
    function this_usage() {
        echo "Usage:   servername_push [options] PATH_FROM PATH TO."
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
        echo "servername_push -u server_username -s server.address.edu.au /home/server/path/*.py ./temp"
        echo "       "
        echo "Becomes:"
        echo "rsync -avz --progress ./temp/* server_username@server.address.edu.au:/home/server/path/"
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

    echo "#rsync -avz --progress ${@:1:$(($#-1))} $usr_name@$srv_name:$last"
    #rsync -avz --progress ${@:1:$(($#-1))} $usr_name@$srv_name:$last
}

#==============================================
# c_loadandgo - Compile and execute a C source on the fly
#
# Examples:
#   c_loadandgo "funcname" followed by any param
#   c_loadandgo psonly mdm
#
# @Params {String} $1: C source filename
#==============================================
function c_loadandgo() {
    [[ $1 ]]    || { echo "Missing operand" >&2; return 1; }
    [[ -r $1 ]] || { printf "File %s does not exist or is not readable\n" "$1" >&2; return 1; }
    local o_path=${TMPDIR:-/tmp}/${1##*/};
    #echo "$o_path"
    local output_path=${o_path%.*};
    #echo "$output_path"
    gcc "$1" -o "$output_path.o" && "$output_path.o";
    rm -f "$output_path.o";
    return 0;
}


#==============================================
#  get_xserver - Get remote host of the session (empty for localhost).
#
# Examples:
#   get_xserver
#==============================================
function get_xserver () {
    local XSERVER=""
    XSERVER=$(LANGUAGE=en who am i | grep  '(' | awk '{print $NF}' | tr -d ')''(' )
    echo "$XSERVER"
}

#==============================================
#  set_display - Automatic setting of $DISPLAY (if not set already).
#
# Examples:
#   set_display
#==============================================
function set_display() {
    if [ -z ${DISPLAY:=""} ]; then
        local XSERVER=`get_xserver`
        if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
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
function exists_fileordir() {
    if [[ -e $1 && ! -L $1 ]]; then
        if [[ -f $1 ||  -d $1 ]]; then
            return 0
        fi
    else
        return 1
    fi
}

#==============================================
# is_active - Check if a service is active on systemd
#
# Examples:
#   is_active "ssh" 
#
# @Params {String} $1: service name
#==============================================
function is_active() {
    if [[ -z "$1" ]]; then
        echo "Usage: is_active <service name>"
        return 1
    fi

    local isact=$(systemctl is-active $1)
    if [ $isact == "active" ]; then
        return 0
    elif  [ $isact == "inactive" ]; then
        return 1
    else
        echo_fail "Error"
        return 1
    fi
}

#==============================================
# activate - Activate a systemd service
#
# Examples:
#   activate "ssh" 
#
# @Params {String} $1: service name
#==============================================
function activate() {
    if [[ -z "$1" ]]; then
        echo "Usage: activate <service name>"
        return 0
    fi

    if is_active "$1"; then
        echo_fail "Error $1 is already running"
    else
        sudo systemctl enable "$1"
        sudo systemctl start "$1"
    fi
}

#==============================================
# deactivate - Deactivate a systemd service
#
# Examples:
#   deactivate "ssh" 
#
# @Params {String} $1: service name
#==============================================
function deactivate() {
    if [[ -z "$1" ]]; then
        echo "Usage: deactive <service name>"
        return 0
    fi

    if is_active "$1"; then
        sudo systemctl stop "$1"
        echo_fail "Error $1 is stopped"
    fi
    sudo systemctl enable "$1"
}

#==============================================
# t - A tree alternative
#
# Examples:
#   t "/home" 
#
# @Params {String} $1: directory name
#==============================================
function t() {
    path="`readlink -m "${1:-$PWD}"`"
    [[ -n $1 ]] && shift
    find "$path" "$@" -print | sed "2,\$s;${path%/*}/;;;2,\$s;[^/]*/; |- ;g;s;-  |;   |;g"
}

#==============================================
# psproc - Show process info
#
# Examples:
#   psproc "firefox" 
#
# @Params {String} $1: process name
#==============================================
function psproc() {
    if [[ -z "$1" ]]; then
        echo "Usage: psproc <process name>"
        return 0
    fi
    if pgrep $1 > /dev/null; then
        echo_pass "Related processes found - $1"
        echo "=========="
        ps -aux | grep $1 | egrep -v 'grep --color=auto' | sort -u
        echo "=========="
    else
        echo_fail "No process related to $1 found"
        return 0
    fi
}

#==============================================
# psonly - Show informacoes sobre um processo
#
# Examples:
#   psonly "firefox" 
#
# @Params {String} $1: process name
#==============================================
function psonly() {
    if [[ -z "$1" ]]; then
        echo "Usage: psonly <process name>"
        return 0
    fi
    if pgrep $1 > /dev/null; then
        echo_pass "$1 instance(s) found"
        echo "=========="
        ps -aux | grep $1 | egrep -v 'grep --color=auto' | sort -u |  awk '{print $1,$2,$11,$12}' | grep $1
        echo "=========="
    else
        echo_fail "No instance of $1 found"
        return 0
    fi
}

#==============================================
# gen_lock - Generat a lock file
#
# Examples:
#   gen_lock "myscript" 
#   gen_lock "myscript" 190
#
# @Params {String} $1: file name
# @Params {String} $2: file descriptor (default 200)
#==============================================
function gen_lock() {
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
function interface_info() {
    if [[ -z "$1" ]]; then
        echo "Usage: interface_info <id interface>"
        return 0
    fi
    if ifdata -e $1; then
        echo_pass "Interface $1 found"
        echo "=========="
        ifdata -p -ph -pf -si -so $1
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
function dtranslate () {
    PS3="${_cl_blue}Select the dictionary: ${_cl_reset}"
    local _options="por-eng eng-por por-fra fra-por por-ita ita-por por-nld nld-por por-deu deu-por tur-por lat-por jpn-por afr-por gla-por exit"
    local w=""

    select i in $_options; do
        if [ $i == "exit" ]; then
            return 0
        else
            printf "${_cl_blue}Enter the word to translate: ${_cl_reset}"
            read w
            echo "Searching..."
            curl dict://dict.org/d:${w}:fd-${i} 2> /dev/null | grep -Ev "html|head|body|h1|hr|center|100|150|220|221|250|251|\%|Dload|\-"
        fi
    done
}

#==============================================
# mostused - Most used Commands
#
# Examples:
#   mostused 
#==============================================
function mostused() {
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
function cd() {
    { [ -z "$1" ] && builtin cd "$HOME";           } || \
    { [ -d "$1" ] && builtin cd "$1";              } || \
    { [ -f "$1" ] && builtin cd "$(dirname "$1")"; } || \
    builtin cd "$1"
}

#==============================================
# md_view - Test markdown files, probably a better way to test for programs.
#
# Examples:
#   md_view  "README.md" 
#   cd /bin
# 
# @Params {String} $1: filename
#==============================================
function md_view() {
    if [[ -z "$1" ]]; then
        echo "Usage: md_view <filename>"
        return 0
    fi
    local i=true
    type -p markdown &> /dev/null || i=false
    if $i ; then
        local output="/tmp/md.view-$(date +%F).html";
        markdown "$1" > "$output";
        xdg-open "$output"; # xdg-open would open default browser after remove line below runs :(
        sleep 2;
        rm -f "$output";
    else
        echo_fail "markdown is not installed"
    fi
}

#==============================================
# phrase - Multiline, case-insensitive grepping (modified from sed & awk O'Reilly book ~pg 138)
#
# Examples:
#   phrase dot README
# 
# @Params {String} $1: text to search
# @Params {String} $2: filename
#==============================================
function phrase() {
    if [[ ( -f "$1" ) || ( ! -f "$2" ) || ( $(echo "$1") == "" ) ]] ; then
        echo 'Usage: phrase "search term" filename';
    fi
    search=$1
    shift
    for file ; do
        sed "/$search/Ib;N;h;s/.*\n//;/$search/Ib;g;s/ *\n/ /;/$search/I{g;b;};g;D;" $file
    done
}

#==============================================
# MIT - use like this in a directory with code you want MIT-licensed: MIT > LICENSE
#
# Examples:
#   MIT
#==============================================
function MIT() {
cat <<EOF
(The MIT License)

Copyright (c) `echo $(date +"%Y")` `echo $USER` <user@email.com>

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
function at_line_no() {
    local LINE_NUMBER=$1
    local LINES_AROUND=${2:-0}
    sed -n "`expr $LINE_NUMBER - $LINES_AROUND`,`expr $LINE_NUMBER + $LINES_AROUND`p"
}

#==============================================
# meteo - Weather from wttr
#
# Examples:
#   meteo
#==============================================
function meteo() {
    local LOCALE=`echo ${LANG:-en} | cut -c1-2`
    cls
    if [ $# -eq 0 ]; then
        local LOCATION=`curl -s ipinfo.io/loc`
    else
        local LOCATION=$1
    fi
    curl -s "$LOCALE.wttr.in/$LOCATION"
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
function escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

#==============================================
# shorten - Truncate each line of the input to X characters (used on pipes)
#
# @option -h:   Help
# @option -l:   Truncate from left instead of right (optional)
# @option -s:   Add STRING when truncated (optional) 
#
# Examples:
#   ls | shorten -s ... 15
#   echo "012345678901234567890" | shorten -s "..." 11
#   echo "012345678901234567890" | shorten -ls "<eol>" 12
# 
# @Params {String} $1: length to truncate to (optional, default 70) 
#==============================================
function shorten () {
    local helpstring="Truncate each line of the input to X characters\n\t-h              Shows this help\n\t-l              Shorten from left side\n\t-s STRING         replace truncated characters with STRING\n\n\t$ ls | shorten -s ... 15"
    local ellip=""
    local left=false
    OPTIND=1
    while getopts "hls:" opt; do
        case $opt in
            l) left=true ;;
            s) ellip=$OPTARG ;;
            h) echo -e $helpstring; return;;
            *) return 1;;
        esac
    done
    shift $((OPTIND-1))

    if $left; then
        cat | sed -E "s/.*(.{${1-70}})$/${ellip}\1/"
    else
        cat | sed -E "s/(.{${1-70}}).*$/\1${ellip}/"
    fi
}

#==============================================
# matches - Find files in the current directory containing the most occurrences of a pattern
#           (Results are output in ascending order by occurrence count)
#
# @option -c Include occurrence counts in output
# @option -r Reverse sort order (default ascending)
# @option -m COUNT Minimum number of matches required to include file in results
# @option -h Display this help screen
#
# Examples:
#   matches -c -m 3 "jekyll"
#   matches -c -r "bash"
# 
# @Params {String} $1: text for search 
#==============================================
function matches () {
    local counts=false
    local minmatches=1
    local patt
    local width=1
    local reverse=""
    local helpstring="Find files in the current directory containing the most occurrences of a pattern\n\t-c         Include occurrence counts in output\n\t-r         Reverse sort order (default ascending)\n\t-m COUNT   Minimum number of matches required\n\t-h         Display this help screen\n\n   Example:\n\t# search for files containing at least 3 occurrences\n\t# of the word \"jekyll\", display filenames with counts\n\n\t$ matches -c -m 3 jekyll"

    OPTIND=1
    while getopts "crm:h" opt; do
        case $opt in
            c) counts=true ;;
            r) reverse="r" ;;
            m) minmatches=$OPTARG ;;
            h) echo -e $helpstring; return;;
            *) return 1;;
        esac
    done
    shift $((OPTIND-1))

    if [ $# -ne 1 ]; then
        echo -e $helpstring
        return 0
    fi

    patt=$1; shift

    OLDIFS=$IFS
    IFS=$'\n'

    declare -a matches=$(while read -r line; do \
                    grep -Hi -c -E "$patt" "$line"; \
                  done < <(grep -lIi -E "$patt" * 2> /dev/null) \
                  | sort -t: -${reverse}n -k 2)
    width=$(echo -n ${matches[0]##*:}|wc -c|tr -d ' ')

    for mtch in ${matches[@]}; do
        if [ ${mtch##*:} -ge $minmatches ]; then
            if $counts; then
                printf "%${width}d: %s\n" ${mtch##*:} "${mtch%:*}"
            else
                echo "${mtch%:*}"
            fi
        fi
    done

    IFS=$OLDIFS
}

#==============================================
#  fstr - Find a pattern in a set of files and highlight them. (needs a recent version of egrep).
#
# @option -c Include occurrence counts in output
# @option -r Reverse sort order (default ascending)
# @option -m COUNT Minimum number of matches required to include file in results
# @option -h Display this help screen
#
# Examples:
#   matches -c -m 3 "jekyll"
#   matches -c -r "bash"
# 
# @Params {String} $1: pattern text for search 
# @Params {String} $2: filename pattern 
#==============================================
function fstr() {
    local mycase=""
    local usage="fstr: find string in files. Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    OPTIND=1
    while getopts :ih opt
    do
        case "$opt" in
           i) mycase="-i " ;;
           *) echo "$usage"; return ;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | xargs -0 egrep --color=always -sn ${mycase} "$1" 2>&- | less -RXS#3M~g
}

#==============================================
# edit - Edit a file normally, or as root
#
# Examples:
#   edit "README"
# 
# @Params {String} $1: filename  
# @Params {String} $2: arg1
# @Params {String} $..: argn
#==============================================
function edit () {
    function argc () {
        local count=0;
        for arg in "$@"; do
            if [[ ! "$arg" =~ '-' ]]; then
                count=$(($count+1));
            fi;
        done;
        echo $count;
    }
    
    if [ -z "$EDITOR" ]; then
        EDITOR="nano"
    fi
    if [[ `argc "$@"` > 1 ]]; then
        $EDITOR $@;
    elif [ -z "$1" ]; then
        $EDITOR;
    elif [ ! -f $1 ] || [ -w $1 ]; then
        $EDITOR "$@";
    else
        echo -n "File is Read-only. Edit as root? (Y/n): "
        read -n 1 yn;
        echo;
        if [ "$yn" = 'n' ] || [ "$yn" = 'N' ]; then
            $EDITOR "$*";
        else
            sudo $EDITOR "$*";
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
function du_full() {
    local dir="$1"
    if [[ -z "$dir" ]]; then
        dir=$( pwd )
        dir=${dir}
    fi

    local usgstr=`df -h "$dir"`
    local usdev=`echo "$usgstr" | awk 'NR==2 { print $1 }'`
    local ustot=`echo "$usgstr" | awk 'NR==2 { print $2 }'`
    local usused=`echo "$usgstr" | awk 'NR==2 { print $3 }'`
    local usfree=`echo "$usgstr" | awk 'NR==2 { print $4 }'`
    local usperc=`echo "$usgstr" | awk 'NR==2 { print $5 }'`
    echo "$usdev - Total:$ustot, Used:$usused, Free:$usfree, Use%:$usperc"
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
function du_short() {
    local d="$1"

    if [[ -z "$d" ]]; then
        d=$(pwd)
        d=${d}
    fi

    local usgstr=`df -h "$d"`
    local usdev=`echo "$usgstr" | awk 'NR==2 { print $1 }'`
    local usperc=`echo "$usgstr" | awk 'NR==2 { print $5 }'`
    echo "$usdev:$usperc"
}

#==============================================
# hosts_up - Active hosts on your LAN
#
# Examples:
#   hosts_up 
#==============================================
function hosts_up() {
    local ip_local=`ip -br -h -4 address | grep "UP" | awk '/UP/{print $3}' | sed -e 's/\/24//g'`
    local ip_neig=`ip -br -h -4 neigh | awk '/dev/{print $1}'`
    local sor_ips=`echo -e "$ip_local\n$ip_neig" | sort`
    echo "$sor_ips"
}

#==============================================
# screens_count - Count active screens. (Doesn't catch named sessions, need to update)
#
# Examples:
#   screens_count 
#==============================================
function screens_count() {
    local sScrPth="/var/run/screen/S-$USER"
    if [ -e "$sScrPth" ]; then
        if [ -n "`find $sScrPth -prune -empty`" ]; then
            echo "0"
        else
            echo  `screen -ls | egrep -c "[0-9]+\.([a-zA-Z0-9\-]+)?\.[a-zA-Z]*"`
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
function screens_and_jobs_count() {
    local all_screens=`screens_count`
    local all_jobs=`jobs_count`
    local results=""

    [ 0 -lt $all_screens ] && [ 0 -lt $all_jobs ] && echo -n "$all_screens Scr|$all_jobs Jobs|" && return
    [ 0 -lt $all_screens ] && [ 0 -eq $all_jobs ] && echo -n "$all_screens Scr|" && return
    [ 0 -eq $all_screens ] && [ 0 -lt $all_jobs ] && echo -n "$all_jobs Jobs|" && return
    echo -n "" && return
}

#==============================================
# Return string length (Locale based)
#==============================================
function strLen() {
    if [[ -z "$1" ]]; then
        echo "Usage: strLen <string>"
        return 0
    fi
    local bytlen
    bytlen=${#1}
    echo  $bytlen
}

#==============================================
# Return string length (LANG=C)
#==============================================
function strLenC() {
    if [[ -z "$1" ]]; then
        echo "Usage: strLenC <string>"
        return 0
    fi
    local bytlen
    local oLang=$LANG
    LANG=C
    bytlen=${#1}
    LANG=$oLang
    echo  $bytlen
}

#==============================================
# Return diff between locale systems for a string
#==============================================
function strU8DiffLen () {
    if [[ -z "$1" ]]; then
        echo "Usage: strU8DiffLen <string>"
        return 0
    fi
    local bytlen oLang=$LANG
    LANG=C
    bytlen=${#1}
    LANG=$oLang
    echo $(( bytlen - ${#1} ))
}

#==============================================
# Show process name of a PID
#==============================================
function process_name() {
    if [[ -z "$1" ]]; then
        echo "Usage: process_name <PID>"
        return 0
    fi
    ps -p $1 -o comm=
    if [ $? != 0 ]; then
        echo ""
    fi
}

#==============================================
# cd and ls in a row
#==============================================
function cl() {
    local dir=$1
    if [[ -z "$dir" ]]; then
        dir=$HOME
    fi
    if [[ -d "$dir" ]]; then
        cd "$dir"
        ls
    else
        echo_fail "bash: cl: '$dir': Diretório não encontrado"
    fi
}

#==============================================
# Extract files 
#==============================================
function do_extract {
    if [ -z "$1" ]; then
        echo "Usage: do_extract <path/filename>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        local f=`echo "$1" | tr '[:upper:]' '[:lower:]'`
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
                *.exe)      cabextract ./$1  ;;
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
function qt_mail() {
    local f="/var/mail/$USER"
    if [ -e "$f" ]; then
        awk '/From:/{print $0}' $f | grep -c "From:"
    else
        echo "0"
    fi
}

#==============================================
# Pending e-mails message
#==============================================
function tem_mail() {
    local qm=""
    qm=$(qt_mail)
    if  [[ $qm -gt 0 ]]; then
        echo "Voce tem $qm novo(s) e-mail(s)!"
    else
        echo "Nenhum e-mail a ser lido"
    fi
}

#==============================================
# String for Git repos status
#==============================================
function prompt_git() {
    local s="";
    local branchName="";
    local is_a_branch=$(git branch &>/dev/null; if [ $? -eq 0 ]; then echo "yes"; else echo "no"; fi)

    # Check if the current directory is in a Git repository.
    if [ "$is_a_branch" == "yes" ]; then
        # check if the current directory is in .git before running git checks
        if [ "`git rev-parse --is-inside-git-dir 2> /dev/null`" == 'false' ]; then
            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null;
            # Check for uncommitted changes in the index.
            if ! `git diff --quiet --ignore-submodules --cached`; then
                s+='+';
            fi;
            # Check for unstaged changes.
            if ! `git diff-files --quiet --ignore-submodules --`; then
                s+='!';
            fi;
            # Check for untracked files.
            if [ -n "`git ls-files --others --exclude-standard`" ]; then
                s+='?';
            fi;
            # Check for stashed files.
            if `git rev-parse --verify refs/stash &>/dev/null`; then
                s+='$';
            fi;
        fi;

        # Get the short symbolic ref.
        # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
        # Otherwise, just give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";

        [ -n "${s}" ] && s="[${s}]";

        #echo -e "${1}${branchName}${2}${s}";
        echo "${1}${branchName}${2}${s} ";
    else
        return 0;
    fi;
}

#==============================================
# A bash_prompt function
#==============================================
function bash_prompt() {
    local git_b_str=""
    local git_prompt=""
    # Checks to see if the current directory is a git repo or not
    local gitcheck_branch=$(git branch &>/dev/null; if [ $? -eq 0 ]; then echo "yes"; else echo "no"; fi)

    if [ "$gitcheck_branch" == "yes" ]; then
        git_b_str=" "`prompt_git`;
        # If we are in a git repo, then check to see if there are uncommitted files
        local gitcheck_status=$(git status | grep "nada a submeter\|nothing to commit" > /dev/null 2>&1; if [ $? -eq 0 ]; then echo "clean"; else echo "unclean"; fi)
        if [ "$gitcheck_status" == "clean" ]; then
            # If there are no uncommitted files, then set the color of the git branch name to green
            git_prompt="$BG$git_b_str"
        else
            # If there are uncommitted files, set it to red.
            git_prompt="$BR$git_b_str"
        fi
    else
        # If we're not in a git repo, then display nothing
        git_prompt=""
    fi

    local sqm=$(qt_mail)
    local sQtma=$(if [ $sqm -eq 0 ]; then echo ""; else echo "$BG✉ "; fi)

    PS1="\$(if [[ \$? == 0 ]]; then echo \"$BG✔\"; else echo \"$BR✘\"; fi) ${sQtma}$BW${debian_chroot:+($debian_chroot)}\u@\h $NONE$BY[\w]$NONE\n$BW  └${git_prompt}$BW─$BG[\A]$BW>$BR \\$ $NONE"
    PS2="\$(echo \"$BG✔\") $NONE"
    PS3=": "
    PS4='$0.$LINENO+ '
    RPS1="\$(echo \"$BG✔\")\w $NONE"
}

#==============================================
# Uptime em portugues
#==============================================
function uptime_active() {
    local Utmc=`uptime -p | tr -d ',' | tr -s ' ' | sed -e 's/up //g' -e 's/year/ano/g' -e 's/month /mes /g' -e 's/months/meses/g' -e 's/week/semana/g' -e 's/day/dia/g' -e 's/hour/hora/g' -e 's/minute/minuto/g'`
    local hasAn=`echo "$Utmc" | grep -o 'ano' | wc -l  || echo -n "0" `
    local hasMe=`echo "$Utmc" | grep -o 'mes' | wc -l  || echo -n "0" `
    local hasSe=`echo "$Utmc" | grep -o 'semana' | wc -l || echo -n "0" `
    local hasDi=`echo "$Utmc" | grep -o 'dia' | wc -l || echo -n "0" `
    local hasHo=`echo "$Utmc" | grep -o 'hora' | wc -l || echo -n "0" `

    if [ "$hasAn" == "1" ]; then
        Utmc=`echo "$Utmc" | sed -e 's/ano /ano, /g' -e 's/anos/anos,/g' `
    fi
    if [ "$hasMe" == "1" ]; then
        Utmc=`echo "$Utmc" | sed -e 's/mes /mes, /g' -e 's/meses/meses,/g' `
    fi
    if [ "$hasSe" == "1" ]; then
        Utmc=`echo "$Utmc" | sed -e 's/semana /semana, /g' -e 's/semanas/semanas,/g' `
    fi
    if [ "$hasDi" == "1" ]; then
        Utmc=`echo "$Utmc" | sed -e 's/dia /dia, /g' -e 's/dias/dias,/g' `
    fi
    if [ "$hasHo" == "1" ]; then
        Utmc=`echo "$Utmc" | sed -e 's/hora /hora e /g' -e 's/horas/horas e/g' `
    fi
    echo "$Utmc"
}

#==============================================
# Returns a random cow file
#==============================================
function random_cow_file() {
    local dircow='/usr/share/cowsay/cows/'
    local cow=`/bin/ls -1 "$dircow" | sort --random-sort | head -1`
    echo "$dircow$cow"
}

#==============================================
# Msg Vc tem email
#==============================================
function you_have_mail() {
    local nQtMail=`qt_mail`
    if  [[ $nQtMail -gt 0 ]]; then
        echo "Voce tem $nQtMail novo(s) e-mail(s)!"
    fi
}

#==============================================
# zsh-like RPROMPT composition function for bash
#==============================================
function __rprompt() {
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
    if  [[ $nQtm -gt 0 ]]; then
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
    if  [[ $nTotLen -gt $nCols ]]; then
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
function draw() {
    local perc=$1
    local size=$2
    local inc=$(( perc * size / 100 ))
    local out=
    if [ -z "$3" ]; then
        local color="36"
    else
        local color="$3"
    fi
    for v in `seq 0 $(( size - 1 ))`; do
        test "$v" -le "$inc" && out="${out}\e[1;${color}m${FULL}" \
        || out="${out}\e[0;${color}m${EMPTY}"
    done 
    printf $out
}

#==============================================
# color bar
#==============================================
function color_bar() {
    printf "\n"
    local i=0
    while [ $i -le 6 ]
    do
      printf "\e[$((i+41))m\e[$((i+30))m█▓▒░"
      i=$(($i+1))
    done
    printf "\e[37m█\e[0m▒░\n\n"
}

#==============================================
# Saudacao de novo shell
#==============================================
function greetings() {
    local USR="`whoami`"
    local DATE="`date +"%d/%m/%Y"`"
    #local DATE="`date +"%A, %d de %B de %Y"`"
    #local DATE="`date +"%a, %d %b de %Y - %T %Z UTC"`"
    local DIST="`~/bin/distro_info -1 | ~/bin/capitalize.sh`"
    local KERNEL="`uname -rmo`"
    local TIMEU="`uptime_active`"
    local TIMEDe="`uptime_since`"
    local FrMEM="`free_mem`"
    local TtMEM="`total_mem`"
    local AvMEM="`avail_mem`"
    #local Wthico=`~/bin/weather -i`
    #local Wthcnd=`~/bin/weather`
    #local Wthmsg=`~/bin/weather -m`
    local BVERS="$BASH_VERSION"

    local FULL=━
    #local EMPTY=━
    #local EMPTY=─
    #local FULL=┅
    local EMPTY=┄

    cls

    printf " \e[1;33mOlá, seja bem vindo. $(you_have_mail)\e[0m\n\n"
    #printf " \e[1;33mHoje está ( $Wthico) $Wthcnd. $Wthmsg.\e[0m\n\n"
    printf " \e[1;36mStatus do Sistema em $DATE:\e[0m\n"
    printf " \e[1;36m     distro  $DIST@ kernel $KERNEL\e[0m\n"
    #printf " \e[1;33m   kernel \e[0m$KERNEL\n"
    printf " \e[1;36m     uptime  $TIMEU desde $TIMEDe\e[0m\n"

    if xhost >& /dev/null ; then
        local id="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
        local id="${id##* }"
        local wm="$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t)"
        local wm="${wm/*_NET_WM_NAME = }"
        local wm="${wm/\"}"
        local wm="${wm/\"*}"
        printf " \e[1;36m      shell  $BVERS @ $wm\e[0m\n"
    else
        printf " \e[1;36m      shell  $BVERS\e[0m\n"
    fi

    #printf " \e[1;33m    clima \e[0m$Wthico $Wthcnd. $Wthmsg.\n"
    #printf " \e[1;33m     data \e[0m$DATE\n"
    #printf " \e[1;33m   distro \e[0m$DIST@ kernel $KERNEL\n"
    ##printf " \e[1;33m   kernel \e[0m$KERNEL\n"
    #printf " \e[1;33m   uptime \e[0m$TIMEU desde $TIMEDe\n"
    #if xhost >& /dev/null ; then
    #    printf " \e[1;33m    shell \e[0m$BVERS @ $wm\n"
    #else
    #    printf " \e[1;33m    shell \e[0m$BVERS\n"
    #fi

    #printf " \e[0m\n"

    # cpu
    local CpuUsg=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | sed "s/\./,/g")
    local CpuLvl=`printf "%.0f" $CpuUsg`
    printf "   \e[0;36m%-4s \e[1;36m%-5s %-25s \n" " cpu" "$CpuLvl%" `draw $CpuLvl 15`

    # ram
    local RamM=`free | awk '/Mem/ {print int($3/$2 * 100.0)}'`
    printf "   \e[0;36m%-4s \e[1;36m%-5s %-25s \n" " ram" "$RamM%" `draw $RamM 15`

    # battery
    #local battery=/sys/class/power_supply/BAT1
    #local BtyFull=$battery/charge_full
    #local BtyNow=$battery/charge_now
    #local bf=`cat $BtyFull`
    #local bn=`cat $BtyNow`
    local charge="$(battery_percentage 2> /dev/null)"
    case 1 in
      $(($charge <= 15)))
        local color='31'
        ;;
      *)
        local color='36'
        ;;
    esac
    printf "   \e[0;${color}m%-4s \e[1;${color}m%-5s %-25s \n" " bat" "$charge%" `draw $charge 15 $color`
    # volume
    if amixer get Master | grep -q 'Right'
    then
        local vol=`amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | tr -d '[]%'`
    else
        local vol=`awk -F"[][]" '/%/ { print $2 }' <(amixer sget Master)  | tr -d '[]%'`
    fi
    if amixer get Master | grep -q '\[off\]'
    then
        local color='31'
    else
        local color='36'
    fi
    printf "   \e[0;${color}m%-4s \e[1;${color}m%-5s %-25s \n" " vol" "$vol%" `draw $vol 15 $color`
    # temperature
    if sensors > /dev/null 2> /dev/null; then
        local SensTemp=`sensors | awk '/Core\ 0/ {gsub(/\+/,"",$3); gsub(/\..+/,"",$3)    ; print $3}'`
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
        printf "   \e[0;${color}m%-4s \e[1;${color}m%-5s %-25s \n" "temp" "$SensTemp˚C " `draw $SensTemp 15 $color`
    fi
    printf "\e[1;33m\n"
    #echo "Data...: $DATE"
    #echo "Distro.: $DIST"
    #echo "Kernel.: $KERNEL"
    #echo "Uptime.: $TIMEU desde $TIMEDe"
    #echo "Memória: Livre: $FrMEM, Total: $TtMEM, Disp: $AvMEM"
    #echo ""
    #echo ""
    ~/bin/my_motd

    echo -e "\n"

    #echo -e "`you_have_mail`\n"

    # Reset colors
    tput sgr0
    #color_bar
}
