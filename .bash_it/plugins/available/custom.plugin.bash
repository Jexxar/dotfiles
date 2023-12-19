# 'custom' functions

#==============================================
# echo replacement 
#==============================================
function echo () {
    local fmt=%s
    local end=\\n
    local OFS="$IFS"
    while [ $# -gt 1 ] ; do
        case "$1" in
            [!-]*|-*[!ne]*) break ;;
            *ne*|*en*) fmt=%b end= ;;
            *n*) end= ;;
            *e*) fmt=%b ;;
        esac
        shift
    done
    IFS=$OFS
    printf "$fmt$end" "$*"
}

#==============================================
# Oneliners
#==============================================
# Short wikipedia description for a given keywork
function wiki() { dig +short txt $1.wp.dg.cx; }
# Weather from wttr.in
#function wttr(){ local LOCATION=$(curl -s ipinfo.io/loc); curl -4 http://wttr.in/${LOCATION}; }
function wttr(){ curl -4 http://wttr.in; }
# View HTTP traffic on a specific network interface
function sniff(){ hash ngrep > /dev/null &&  sudo ngrep -d '${1}' -t '^(GET|POST) ' 'tcp and port 80'; }
function httpdump(){ hash tcpdump > /dev/null && sudo tcpdump -i ${1} -n -s 0 -w - | grep -a -o -E "\"Host\: .*|GET \/.*\""; }
# Customized ps 
function psa(){ ps -axf -o pid,%cpu,%mem,bsdtime,user,command ;}
# Simple watch for free mem
function memw(){ watch -n 1 free -h ;}
# See memory usage precentage
function msumm(){ awk -v"RS=~" '{print "Total:", $2/1024000, "GiB","|","In Use:",100-$5/$2*100"%"}' /proc/meminfo; }
# Show current distro name
function mydistro(){ ~/bin/distro-info -2 ;}
# Show all tcp listeners 
function listeners(){ sudo LC_ALL=C lsof -i | grep "LISTEN" || echo "No listeners found" ;}
# Ping connection test on canonical.com
function pgca(){ ping -c3 canonical.com ;}
# Superuser active ports report
function ports(){ hash netstat > /dev/null && sudo LC_ALL=C netstat -tulanpe ;}
# Active inet ports
function ns(){ hash netstat > /dev/null && LC_ALL=C netstat -alnp --protocol=inet | grep -v "CLOSE_WAIT" | cut -c-6,21-94 ;}
# Simple log analyzer function
function logs(){ find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f ;}
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
function my_ps(){ ps -eo etimes,ruser,pid,ppid,cmd --sort=start_time | awk 'BEGIN{now=systime()} {$1=strftime("%Y-%m-%d-%H:%M:%S", now-$1); print $0}' | awk -v u=$USER '$2 == u { print $0 }' | grep -v "grep\|awk\|ps -e"; }
# Custom my user processes tree
function psgrep(){ my_ps | awk '!/awk/ && $0~var' var="${1:-".*"}" | grep -v "grep\|awk" ; }
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
function h24(){ date -Ins | cut -b 12-19 ; }
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
function mostcolor(){ cat "$1" | sed 's/#fields\t\|#types\t/#/g' | awk 'BEGIN {FS="\t"};{for(i=1;i<=NF;i++) printf("\x1b[%sm %s \x1b[0m",(i%7)+31,$i);print ""}' | most -S; }
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
# Commandline FU MOTD
function cm_fu_motd(){ curl http://www.commandlinefu.com/commands/random/plaintext -o "$HOME"/.motd -s -L && cat "$HOME"/.motd ; }
# Command line Calculations
function calc(){ printf '%s\n' "scale=3;${*//[ ]}" | bc -l ; }
# Run dig and display the most useful info
function digga(){ dig +nocmd +multiline +noall +answer "$1"; }
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
# Get_xserver - Get remote host of the session (empty for localhost).
function get_xserver(){ echo "$(LC_ALL=C who am i | grep  '(' | awk '{print $NF}' | tr -d ')''(' )" ;}

#==============================================
# la - Better sorted ls using find and xargs
#
# Examples:
#    la .
#    la ~/Downloads
#==============================================
function la(){ 
    local _nm="$@"
    [ -z "$_nm" ] && _nm="."
    LC_ALL=C find "$_nm" -maxdepth 1 -xdev -print0 | /bin/sed 's/\.\///g' | \
            xargs -0 ls -dlavhF  --color=auto --time-style=long-iso --group-directories-first;
}

#==============================================
# hstrnotiocsti - hstr helper function
#==============================================
function hstrnotiocsti(){
#    { READLINE_LINE="$( { </dev/tty hstr ${READLINE_LINE}; } 2>&1 1>&3 3>&- )"; } 3>&1;
    { READLINE_LINE="$( { </dev/tty hstr "$*"; } 2>&1 1>&3 3>&- )"; } 3>&1;
    READLINE_POINT=${#READLINE_LINE}
}
 
#==============================================
# undup_bash_history - Remove all duplicated lines from bash_history file.
#
# Examples:
#    undup_bash_history
#==============================================
function undup_bash_history(){
    [ -z "$HISTFILE" ] && export HISTFILE="$HOME/.bash_history"
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
    local _cmd="";
    local _parm="$*"
    if [ -z "$HISTFILE" ]; then
        export HISTFILE="$HOME/.bash_history"
    fi
    if hash hstrnotiocsti > /dev/null 2>&1 ; then
        hstrnotiocsti "$*"
        if [ -n "$READLINE_LINE" ]; then
            _cmd="$READLINE_LINE"
            unset READLINE_LINE
            eval "$_cmd"
        fi
    elif hash fzy > /dev/null 2>&1 ; then
        _cmd=$(grep "$*" "$HISTFILE" | fzy)
        [ -n "$_cmd" ] && eval "$_cmd"
    elif hash fzf > /dev/null 2>&1 ; then
        _cmd=$(grep "$*" "$HISTFILE" | fzf)
        [ -n "$_cmd" ] && eval "$_cmd"
    elif hash hstr > /dev/null 2>&1 ; then
        hstr "$*"
    fi
}

#==============================================
# Make sure "view" works and prevent the normal ensuing keyboard input chaos.
#==============================================
function view {
    if [ -p /dev/stdin ]; then 
        local AS_FILE=$(mktemp)
        cat /dev/stdin >| "$AS_FILE"
        command view "$AS_FILE"
        rm -f "$AS_FILE"
        return 0
    fi
    if [ $# -eq 0 ]; then
        echo "You must provide a file to view"
        return 1
    fi
    local args=("$@");
    command view "${args[@]}";
}

#==============================================
# grtxt - Search for text within the current directory.
#
# Examples:
#    grtxt test 
#
# @param {String} $*  search string
#==============================================
function grtxt(){
    #     ┌─ ignore case
    #     │┌── search all files under each directory, recursively
    grep -iRn --color=always "$*" --exclude-dir=".git" --exclude-dir="node_modules" . | less -RXS#3M~g
    #       display ANSI color escape sequences in raw form ─────────────────────────────────┘│
    #           don't clear the screen after quitting less ───────────────────────────────────┘
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
        hash host && host "$1" > /dev/null
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
    local rel_path="$1"
    [ -z "$rel_path" ] && rel_path=$(pwd)
    local user_home="${HOME//\//\\\/}";
    local user_home_sed="s#~#${user_home}#g";
    rel_path=$(echo "${rel_path}" | sed "${user_home_sed}");
    local result=$(readlink -e "${rel_path}");
    echo "${result}";
}

#==============================================
# set_display - Automatic setting of $DISPLAY (if not set already).
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
# ifinfo - Show info about a network interface
#
# Examples:
#   interface_info "lo" 
#   interface_info "enp4s0"
#
# @Params {String} $1: interface name
#==============================================
function ifinfo(){
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
    local n=$(type -p nano 2> /dev/null)
    [ -z "$EDITOR" ] && [ -n "$n" ] && EDITOR="$n"
    [ -z "$EDITOR" ] && {
        n=$(type -p micro 2> /dev/null)
        [ -n "$n" ] && EDITOR="$n"
        [ -z "$EDITOR" ] && echo "No suitable editor found..." && return 1
    }
    if [ -z "$1" ]; then
        $EDITOR 
    elif [ ! -f "$1" ] || [ -w "$1" ]; then
        $EDITOR "$@"
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
    local ip_neig=$(ip -br -h -4 neigh | grep -v "FAILED" | awk '{print $1}')
    echo -e "$ip_local\n$ip_neig" | sort
}

#==============================================
# Show process name of a PID
#==============================================
function psname(){
    if [ -n "$1" ]; then ps -p $1 -o comm= ;return 0; fi
    echo "Usage: psname <PID>" && return 1
}

#==============================================
# Retrieve pending e-mails quantity
#==============================================
function qt_mail(){
    [ -e /var/mail/$USER ] && awk '/From:/{print $0}' /var/mail/$USER 2> /dev/null | grep -c "From:" || echo 0
}

#==============================================
# Msg you have mail
#==============================================
function you_have_mail(){
    local qtm=$( [ -e /var/mail/$USER ] && awk '/From:/{print $0}' /var/mail/$USER 2> /dev/null | grep -c "From:" || echo 0 )
    [ $qtm -gt 0 ] && echo "You have $qtm unread mail(s)!"
    return 0
}

#==============================================
# Uptime extended
#==============================================
function uptime_active(){
    uptime -p | tr -s ' ' | sed -e 's/up //g'
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
# find wm (window manager)
#==============================================
function find_wm(){
    local wm=""
    [ -n "$XDG_CURRENT_DESKTOP" ] && wm="$XDG_CURRENT_DESKTOP" && echo "$wm" && return 0
    hash wmctrl 2> /dev/null  && wm=$(wmctrl -m | awk '/Name:/ {print $2}')
    [ -n "$wm" ] && echo "$wm" && return 0
    wm="$(ps -e | grep -i "^.*wm\|i3\|awesome\|sway\|openbox\|blackbox\|fluxbox" | awk 'NR == 1 {print $4}')"
    [ -n "$wm" ] && echo "$wm" && return 0
    hash xprop 2> /dev/null && {
        local id="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK 2> /dev/null | grep "id" | awk '{print $5}')"
        [ -n "$id" ] && wm="$(xprop -id "$id" -notype -len 100 -f _NET_WM_NAME 8t | grep "_NET_WM_NAME" | awk '{gsub(/"/, "", $3); print $3 }')"
    }
    [ -n "$DESKTOP_SESSION" ] && wm="$DESKTOP_SESSION" && echo "$wm" | tr '[:upper:]' '[:lower:]' | sed -e "s/\b\(.\)/\u\1/g" && return 0
    echo "$wm"
    return 0
}

#==============================================
# Greetings (A kind of fetch info display)
#==============================================
function greetings(){
    local DIST="$(~/bin/distro-info -1 | tr '[:upper:]' '[:lower:]' | sed -e "s/\b\(.\)/\u\1/g")"
    DIST="$(rstrip $DIST " ")"
    local KERNEL="$(uname -rmo)"
    local TIMEU="$(uptime_active)"
    local TIMEDe="$(uptime_since)"
    local FrMEM="$(free_mem)"
    local TtMEM="$(total_mem)"
    local AvMEM="$(avail_mem)"
    local BVERS="$BASH_VERSION"
    local FULL=━
    local EMPTY=┄
    local DATE="$(date +"%Y/%m/%d")"

    cls
    printf " \e[1;33mHi, Welcome. $(you_have_mail)\e[0m\n\n"
    printf " \e[1;36mSystem Status in $DATE:\e[0m\n"
    printf " \e[1;36m     distro  $DIST @ kernel $KERNEL\e[0m\n"
    printf " \e[1;36m     uptime  $TIMEU since $TIMEDe\e[0m\n"
    if xset q &>/dev/null ; then
        local wm="$(find_wm)"
        printf " \e[1;36m      shell  $BVERS @ $wm\e[0m\n"
    else
        printf " \e[1;36m      shell  $BVERS\e[0m\n"
    fi
    # cpu
    local CpuUsg=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
    local CpuLvl=$(LC_ALL=C printf "%.0f" $CpuUsg)
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

    hash my-motd 2> /dev/null && my-motd

    echo -e "\n"
    #echo -e "$(you_have_mail)\n"
    # Reset colors
    tput sgr0
}
