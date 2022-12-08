#!/usr/bin/env bash
#set -eu

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

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

function main() {
    #local OLD_IFS=$IFS
    #IFS=$'\n'
    #for f in $(grep -lIi -E "bash" * 2> /dev/null | sort -t: -${reverse}n -k 2); do
    #    str="$(grep -Hi -c -E "bash" "$f")"
    #    echo "file: $f string: $str count: ${str##*:}"
    #done
    #IFS=$OLD_IFS
    #return 0
    
    #echo "======================================"
    #precheck "dump_xsettings"
    #precheck "gsettings"
    
    #echo "======================================"
    #echo " ------ now logging whith tee for log files ----------"
    #echo "$myLogPath"
    #echo "$myLogFile"
    #info "info - do some logging1 $(timestamp)"
    #log "log  - do some logging1 $(timestamp)"
    #info "tee  - do some logging1 $(timestamp)" | tee -a "$myLogFile" > /dev/null
    #echo
    #echo
    #echo " ------ dstart testing ----------"
    #if [ $(pgrep -lfc volumeicon) -eq 0 ] && [ $(pgrep -lfc mate-volume-control-applet) -eq 0 ] ; then
    #    echo "dstart volumeicon"
    #else
    #    echo "volume ok"
    #fi
    #echo "======================================"
    #echo " ------ stopit xautolock ----------"
    #stop_it "xautolock"
    #log "enableScrXautolock(): (Re)/Starting xautolock daemon..."
    #xautolock -detectsleep -noclose -time 5 -locker "\"$HOME/bin/mylock\"" -notify 30 -notifier "\"$HOME/bin/mynotify\"" -killtime 10 -killer "\"$HOME/bin/mysuspend\"" &
    #snore 0.5
    #stop_it "xautolock"
    #echo "======================================"
    #yad --width 300 --title "System Logout" --image=gnome-shutdown --button="Cancel:6" --button="Lock:5" --button="Power Off:4" --button="Reboot:3" --button="Suspend:2" --button="Logout:1" --fontname="Sans bold 16" --text='<span font="26">'"    Pick up a choice"'</span>' --center --on-top --undecorated
    #local yrc=$?
    #echo "$yrc"
    #echo "======================================"
    #echo " ------ url decoding ----------"
    #echo "original=V%C3%ADdeos urldecode=$(urldecode "V%C3%ADdeos")"
    #echo "======================================"
    #echo " ------ checkfor ----------"
    #checkfor "inxi" && echo "inxi encontrado"  || echo "inxi nao encontrado"
    #checkfor "firefox" && echo "firefox encontrado" || echo "firefox nao encontrado"
    #echo "======================================"
    #echo " ------ findutil ----------"
    #echo "$(findutil inxi)"
    #echo "$(findutil firefox)"
    #echo "======================================"
    #echo " ---- iconPath icon_name=\"error\" ----"
    #local tn="$(findIconThemeName)"
    #echo "findIconThemeName......: $tn"
    #local tpt="$(findIconThemePath "$tn")"
    #echo "findIconThemePath......: $tpt"
    #ipt=$(findNrmIconHelper "$tpt" "error.svg")
    #echo "from findNrmIconHelper.: $ipt"
    #ipt=$(findStatIconHelper "$tpt" "error.svg")
    #echo "from findStatIconHelper: $ipt"
    #echo "iconPath file..........: $(iconPath "error")"
    #ipt=$(FallbackiconPath "error" "$tpt")
    #echo "from FallbackiconPath..: $ipt"
    #echo "======================================"
    #echo " ------ trim_spaces ---"
    #echo "trim_spaces \"   example   string    \""
    #trim_spaces "   example   string    "
    #echo "trim \"   example   string    \""
    #trim "   example   string    "
    #echo "rtrim \"   example   string    \""
    #rtrim "   example   string    "
    #echo "ltrim \"   example   string    \""
    #ltrim "   example   string    "
    #echo "======================================"
    #echo "\$\$ outside of subshell = $$"                              # 9602
    #echo "\$BASH_SUBSHELL  outside of subshell = $BASH_SUBSHELL"      # 0
    #echo "\$BASHPID outside of subshell = $BASHPID"                   # 9602
    
    #echo
    #( echo "\$\$ inside of subshell = $$"                             # 9602
    #    echo "\$BASH_SUBSHELL inside of subshell = $BASH_SUBSHELL"    # 1
    #echo "\$BASHPID inside of subshell = $BASHPID" )                  # 9603
    # Note that $$ returns PID of parent process.
    #echo "======================================"
    #echo " ------ ps_ISO testing ---"
    #ps_ISO
    #echo "======================================"
    #echo " ------ ps_ISO testing script name 001 ---"
    #ps_ISO "${0##*/}"
    #echo " ------ ps_ISO testing script name 002 ---"
    #ridic=`ps_ISO "${0##*/}"`
    #echo "$ridic"
    #echo " ------ ps_ISO testing script name 003 ---"
    #ridic=$(ps_ISO "${0##*/}")
    #echo "$ridic"
    #echo "$ridic" | awk '{print $3}'
    #echo " ------ ps_ISO testing script name 004 ---"
    #ps_ISO "${0##*/}" | awk '{print $3}'
    #echo " ------ ps_ISO testing script name 005 ---"
    #ps_ISO "${0##*/}" | grep "$USER" | grep -P "bash" | grep -v "grep" | awk '{print $3}'
    #echo " ------ ps_ISO testing script name 006 ---"
    #ps_ISO "${0##*/}" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "${0##*/}" | awk '{print $1}'
    #echo "-------------------------"
    #echo "======================================"
    #echo " mywallchng -- ps_ISO use of in kill_them"
    #ps_ISO "mywallchng"
    #ps_ISO "mywallchng" | sed 's/bash //g' | awk '{print $3}'
    #ps_ISO "mywallchng" | sed 's/bash //g'
    #ps_ISO "mywallchng" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}'
    #ps_ISO "mywallchng" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "mywallchng" | awk '{print $1}'
    #echo "======================================"
    #echo "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #echo "----- ps_ISO ---"
    #ps_ISO "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #echo "------ kill_them  ---"
    #kill_them "check" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #kill_them "sh-c" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #kill_them "strict" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #echo "======================================"
    #echo "pcmanfm-qt -- ps_ISO 001"
    #ps_ISO "pcmanfm-qt"
    #echo "pcmanfm-qt -- ps_ISO 002"
    #ps_ISO "pcmanfm-qt" | sed 's/bash //g' | grep -v "bash\|sh -c\|grep"
    #echo "pcmanfm-qt -- ps_ISO 003"
    #ps_ISO "pcmanfm-qt" | sed 's/bash //g' | awk '!/sh -c/ && $0~".*"'
    ##echo "======================================"
    #echo "----- kill_them ---"
    #kill_them "check" "pcmanfm-qt"
    #kill_them "sh-c" "pcmanfm-qt"
    #kill_them "strict" "pcmanfm-qt"
    #echo "======================================"
    #echo "autoping"
    #echo "----- ps_ISO ---"
    #ps_ISO "autoping"
    #echo "----- kill_them ---"
    #kill_them "check" "autoping" "s"
    #kill_them "sh-c" "autoping" "s"
    #kill_them "strict" "autoping"
    #echo "======================================"
    #echo "tilix"
    #echo "----- ps_ISO ---"
    #ps_ISO "tilix"
    #echo "----- kill_them ---"
    ##kill_them "check" "tilix" "s"
    #kill_them "sh-c" "tilix" "s"
    #echo "======================================"
    #echo "bash"
    #echo "----- ps_ISO ---"
    #ps_ISO "bash"
    #echo "----- kill_them ---"
    #kill_them "check" "bash" "s"
    #echo "======================================"
    #echo "firefox"
    #echo "----- ps_ISO ---"
    #ps_ISO "firefox"
    #echo "----- kill_them ---"
    #kill_them "check" "firefox" "s"
    #kill_them "sh-c" "firefox" "s"
    #echo
    #echo "======================================"
    #echo "lsof_p firefox -- no filter"
    #lsof_p "firefox"
    #echo "======================================"
    #echo "lsof_p firefox -- filtered"
    #lsof_p "firefox" | grep -v "xpi\|startupCache\|omni\|\.mozilla"
    #echo "======================================"
    #echo "lsof_p sublime_text"
    #lsof_p "sublime_text"
    #echo "======================================"
    #echo "lsof_p pcmanfm -- no filter"
    #lsof_p "pcmanfm"
    #echo "lsof_p pcmanfm -- filtered"
    #lsof_p "pcmanfm" | grep -v "pcmanfm-\|fonts\|/proc\|/dev/pts\|/sys/dev\|/usr/share/pcmanfm"
    #echo "======================================"
    #echo "lsof_p pcmanfm-qt -- no filter"
    #lsof_p "pcmanfm-qt"
    #echo "lsof_p pcmanfm-qt -- filtered"
    #lsof_p "pcmanfm-qt" | grep -v "pcmanfm-qt-\|fonts\|/proc\|/dev/pts\|/sys/dev\|/usr/share/pcmanfm"
    #echo "======================================"
    #echo "lsof_p chrome"
    ##ps_ISO "chrome" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "chrome" | awk '{print $1}'
    #lsof_p "chrome" | grep -v "fonts\|/proc\|/dev/pts\|omni\|chrome\|\.pki\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p wget"
    ##ps_ISO "wget" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "wget" | awk '{print $1}'
    #lsof_p "wget" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p curl"
    #ps_ISO "curl" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "curl" | awk '{print $1}'
    #lsof_p "curl" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p transmission"
    #ps_ISO "transmission" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "transmission" | awk '{print $1}'
    #lsof_p "transmission" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p nautilus"
    #ps_ISO "nautilus" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "nautilus" | awk '{print $1}'
    #lsof_p "nautilus" | grep -v "nautilus-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p caja"
    #ps_ISO "caja" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "caja" | awk '{print $1}'
    #lsof_p "caja" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p sftp"
    #ps_ISO "sftp" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "sftp" | awk '{print $1}'
    #lsof_p "sftp" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p synaptic"
    #ps_ISO "synaptic" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "synaptic" | awk '{print $1}'
    #lsof_p "synaptic" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "======================================"
    #echo "lsof_p alarm-clock-applet"
    #ps_ISO "alarm-clock-applet" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "alarm-clock-applet" | awk '{print $1}'
    #lsof_p "alarm-clock-applet" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    #echo "_lsof alarm-clock-applet"
    #echo "======================================"
    #_lsof
    #echo "_lsof - all"
    #echo "======================================"
    #echo "lsof_p librewolf - no filter"
    #echo "---librewolf----------------------------------------"
    #lsof_p "librewolf"
    #echo "---LibreWolf----------------------------------------"
    #lsof_p "LibreWolf"
    #echo "======================================"
    #echo "lsof_p librewolf - filtered"
    #echo "---librewolf----------------------------------------"
    #lsof_p "librewolf" | grep -v "/tmp\|fonts\|/proc\|/dev/pts\|/dev/tty\|/sys/dev\|xpi\|startupCache\|omni\|\.librewolf\|AppImage\|fuse"
    #echo "---LibreWolf----------------------------------------"
    #lsof_p "LibreWolf" | grep -v "/tmp\|fonts\|/proc\|/dev/pts\|/dev/tty\|/sys/dev\|xpi\|startupCache\|omni\|\.librewolf\|AppImage\|fuse"
    #echo "======================================"
    #echo "ps_ISO of caja"
    #ps_ISO "caja"
    #echo "-----------"
    #echo "lsof_p caja -- no filter"
    #lsof_p "caja"
    #echo "lsof_p caja -- filtered"
    #lsof_p "caja" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev\|/usr/share/caja"
    #echo "======================================"
    #echo "ps_ISO of nautilus"
    #ps_ISO "nautilus"
    #echo "-----------"
    #echo "lsof_p nautilus -- no filter"
    #lsof_p "nautilus"
    #echo "======================================"
    #echo "ps_ISO of mc"
    #ps_ISO "mc"
    #echo "-----------"
    #echo "lsof_p mc -- no filter"
    #lsof_p "mc"
    #echo "======================================"
    #echo "lsof_p LibreWolf -- no filter"
    #lsof_p "LibreWolf"
    #lsof_p "libreWolf"
    #echo "======================================"
    #echo "lsof_p LibreWolf -- filtered .mozilla"
    #lsof_p "LibreWolf" | grep -v "xpi\|startupCache\|omni\|\.mozilla\|AppImage\|fuse"
    #echo "lsof_p libreWolf -- filtered .librewolf"
    ##lsof_p "libreWolf" | grep -v "xpi\|startupCache\|omni\|\.librewolf\|AppImage\|fuse"
    #lsof_p "librewolf" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev\|xpi\|startupCache\|omni\|\.librewolf\|AppImage\|fuse"
    #echo "======================================"
    #echo "_lsof - search for Downloads"
    #_lsof  | grep -i "Downloads"
    #echo "======================================"
    #echo "======================================"
    #echo "_lsofdown"
    #_lsofdown
    #echo
    #echo "_lsof - virtualbox"
    #_lsof | grep -i "virtual"
    #echo "batata is $(findutil "batata")"
    #echo "$?"
    #echo "ping is $(findutil "ping")"
    #echo "launching xautolock"
    #xautolock -detectsleep -noclose -time 5 -locker "\"$HOME/bin/mylock\"" -notify 30 -notifier "\"$HOME/bin/mynotify\"" -killtime 10 -killer "\"$HOME/bin/mysuspend\"" &
    #sleep 2
    #echo "teste stop_it"
    #stop_it "xautolock" "stop"
    #echo "======================================"
    #echo "ps_ISO of $USER"
    #echo " "
    #local OLD_IFS=$IFS
    #local cml=""
    #IFS=$'\n'
    #for f in $(ps_ISO | grep "^[0-9].* $USER" | sed 's/bash/###/g' | sed 's/### //g' | sed 's|/usr/bin/python ||g' | sed 's|/usr/bin/python3 ||g' | grep -v "$0\|###\|openbox\|dbus\|keeptty\|ssh-agent\|sd-pam\|gpg-agent\|sed\|grep\|dbus\|gvfs\|systemd --user\|/ps -aux\|contentproc"); do
    #    cml="$(awk '{print $5}' <<< "$f")"
    #    #echo "$f"
    #    cml="${cml##*/}"
    #    echo "$cml"
    #done
    #IFS=$OLD_IFS
    #exit 0
    # Stop this session and user daemon running processes.
    #stop_it "pulseaudio"
    #echo "======================================"
    #echo "ps_ISO of $USER"
    #local app_filter="${0##*/}\|###\|gconf\|dconf\|openbox\|dbus\|keeptty\|ssh-agent\|sd-pam\|gpg-agent\|sed\|grep\|dbus\|gvfs\|systemd --user\|/ps -aux\|contentproc\|plugin_host"
    #local OLD_IFS=$IFS
    #local cml=""
    #IFS=$'\n'
    #for x in $(ps_ISO | grep "^[0-9].* $USER" | sed 's/bash/###/g' | sed 's/### //g' | sed 's/ sh -c//g' | sed 's|/bin/sh -c ||g' | sed 's|/bin/sh ||g' | sed -E 's|/usr/bin/python.? ||g' | grep -v "$app_filter"); do
    #    cml=$(awk '{print $5}' <<< $x)
    #    cml="${cml##*/}"
    #    #[ -n "$cml" ] && stop_it "$cml" || true
    #    #[ -n "$cml" ] && log "stopping $cml" && stop_it "$cml" || true
    #    [ -n "$cml" ] && log "stop_it $cml" && echo "stop_it $cml    => $x" || true
    #done
    #IFS=$OLD_IFS
    #[ -z "$XDG_CURRENT_DESKTOP" ] && export XDG_CURRENT_DESKTOP="$(wmctrl -m | awk '/Name:/ {print $2}')" && echo "xdg desktop = $XDG_CURRENT_DESKTOP"
    #log "Exiting now..."
    #[ "$XDG_CURRENT_DESKTOP" == "Openbox" ] && openbox --exit;
    #ls "${BASH_IT}/plugins/enabled/"
    #echo "1) BASH_IT/plugins/enabled pure"
    #echo "${BASH_IT}/plugins/enabled/*${BASH_IT_LOAD_PRIORITY_SEPARATOR}"
    #echo "2) foo simple assign BASH_IT"
    #foo="${BASH_IT}/plugins/enabled/*${BASH_IT_LOAD_PRIORITY_SEPARATOR}"
    #echo "$foo"
    #ls $foo${BASH_IT_LOAD_PRIORITY_SEPARATOR}"custom.plugin.bash"
    #echo "3) bar = echo BASH_IT/plugins/enabled/*"
    #bar=$(echo "${BASH_IT}/plugins/enabled/*")
    #echo $bar
    #echo "4) foo concat -e option"
    #ls $foo${BASH_IT_LOAD_PRIORITY_SEPARATOR}"custom.plugin.bash"
    #[ -e $foo${BASH_IT_LOAD_PRIORITY_SEPARATOR}"custom.plugin.bash" ] && echo "OK did it"
    #if [ -e "${BASH_IT}/plugins/enabled/custom.plugin.bash" ] || [ -e "${BASH_IT}/plugins/enabled/*"${BASH_IT_LOAD_PRIORITY_SEPARATOR}"custom.plugin.bash" ]; then
    #    printf '%s\n' 'custom found'
    #else
    #    printf '%s\n' 'custom not found'
    #fi
    #local tmp="https://github.com/LukeSmithxyz/dwmblocks.git"
    #local aux="${tmp##*/}"
    #local repodir="${aux%}"
    #local progname="${aux%.git}"
    #local dir="$progname"
    #echo "aux $aux"
    #echo "progname $progname"
    #echo "repodir $repodir"
    #echo "dir $dir"
    #local _DISTRIB_ID="$(grep 'DISTRIB_ID' /etc/*-release  2> /dev/null | awk -F[=] '/DISTRIB_ID/ {print $2}' | sed -e "s/\"//g" | tr '[:upper:]' '[:lower:]')"
    #local _DISTRIB_ID="ret"
    #echo $_DISTRIB_ID
    #case $_DISTRIB_ID in
    #    mint*)  echo " " ;;
    #    arc*)  echo " " ;;
    #    debian*)  echo " " ;;
    #    ubunt*)  echo " " ;;
    #    fedora*)  echo " " ;;
    #    manjaro*)  echo " " ;;
    #    *suse*)  echo " " ;;
    #    gentoo*)  echo " " ;;
    #    *hat*)  echo " " ;;
    #    void*)  echo " " ;;
    #      *) echo " " ;;
    #esac
    #case $_DISTRIB_ID in
    #    mint*) echo "22" ;;
    #    arc*) echo "18" ;;
    #    debian*) echo "53" ;;
    #    ubunt*) echo "88" ;;
    #    fedora*) echo "104" ;;
    #    manjaro*) echo "22" ;;
    #    *suse*) echo "29" ;;
    #    gentoo*) echo "56" ;;
    #    *hat*) echo "16" ;;
    #    void*) echo "64" ;;
    #    *) echo "0" ;;
    #esac
    # enumerate all the attached screens
    #local _displays=$(xvinfo | awk -F'#' '/^screen/ {print $2}' | xargs)
    ##echo "$_displays"
    #local wlist=""
    #local dlApps=('vlc' 'celluloid' 'xplayer' 'bino' 'curlew' 'avidemux' 'mpv' 'smplayer' 'smtube' 'gmpc' 'ardour2' 'xine' 'totem' 'parole' 'qmmp' 'kaffeine' 'kmplayer' 'kdenlive' 'ffmpeg')
    #local ft="$(echo "${dlApps[@]}" | sed -e 's/ /\\\|/g')"
    #echo "$ft"
    #local dndApps=('sublime_text' 'geany' 'vim' 'nano' 'micro' 'vscode')
    #local dlWebBasedApps=('firefox' 'qutebrowser' 'librewolf' 'chrome' 'vivaldi' 'brave' 'chromium' 'epiphany' 'webkit' 'opera' 'iceweasel' 'surf' 'yandex_browser' 'luakit'  'midori' 'min ' 'falkon' 'slimjet' 'steam')
    #local OLD_IFS=$IFS
    #IFS=$'\n'
    #for d in $_displays; do
    #    wlist="$(DISPLAY=:${d} wmctrl -l -p -x -G)"
    #    for w in $wlist; do
    #        #echo "$w"
    #        local wid="$(awk '{print $1}' <<< $w)"
    #        local wpid="$(awk '{print $3}' <<< $w)"
    #        local wcls="$(awk '{print $8}' <<< $w | awk -F[.] '{print $2}' | tr '[:upper:]' '[:lower:]')"
    #        if [ $(DISPLAY=:${d} xprop -id "$wid" _NET_WM_STATE 2> /dev/null | grep -c _NET_WM_STATE_FULLSCREEN) -gt 0 ]; then
    #            #echo "$wcls"
    #            if [[ " ${dlApps[*]} " =~ ${wcls} ]]; then
    #                echo "$wcls in dlApps is in fullscreen mode"
    #            fi
    #            if [[ " ${dndApps[*]} " =~ ${wcls} ]]; then
    #                echo "$wcls in dndApps is in fullscreen mode"
    #            fi
    #            if [[ " ${dlWebBasedApps[*]} " =~ ${wcls} ]]; then
    #                echo "$wcls in dlWebBasedApps is in fullscreen mode"
    #            fi
    #        fi
    #        if [ $(DISPLAY=:${d} xprop -id "$wid" _NET_WM_STATE 2> /dev/null | grep -c _NET_WM_STATE_ABOVE) -gt 0 ]; then
    #            #echo "$wcls"
    #            if [[ " ${dlApps[*]} " =~ ${wcls} ]]; then
    #                echo "$wcls in dlApps is in Above screen mode"
    #            fi
    #            if [[ " ${dndApps[*]} " =~ ${wcls} ]]; then
    #                echo "$wcls in dndApps is in Above screen mode"
    #            fi
    #            if [[ " ${dlWebBasedApps[*]} " =~ ${wcls} ]]; then
    #                echo "$wcls in dlWebBasedApps in Above ullscreen mode"
    #            fi
    #        fi
    #    done
    #done
    #IFS=$OLD_IFS
    #local _pid="$(xprop -id "0x01600003" _NET_WM_PID 2> /dev/null | awk '{print $3}')"
    #local class="$(xprop -id "0x02a00003" WM_CLASS | tr '[:upper:]' '[:lower:]' | awk -F[=,] '{gsub(/"/, "", $3);print $3}')"
    #[ -z "${class##*sublime_text*}" ] && echo "WOW it works class=$class"
    #local p="$(ps -p $_pid -o comm=)"
    #p="$(grep -o "$p" <<< ${dndApps[@]})"
    #echo "p=$p"
    #runcheck "$class" "$p" && echo "YES $p fullscreen detected" || echo "No fullscreen detected"
    #local su_no_pw="$(sudo -l | grep "NOPASSWD")"
    #[ -z "${su_no_pw##*pm-suspend*}" ] && echo "su_no_pw contain pm-suspend"
    #[ -z "${su_no_pw##*systemctl suspend*}" ] && echo "su_no_pw contain systemctl suspend"
    #local string='echo "My string"'
    #for reqsubstr in 'o "M' 'alt' 'str';do
    #    if [ -z "${string##*$reqsubstr*}" ] ;then
    #        echo "String '$string' contain substring: '$reqsubstr'."
    #    else
    #        echo "String '$string' don't contain substring: '$reqsubstr'."
    #    fi
    #done
    #echo "getOnlineMediaWList"
    #local wlst="$(getOnlineMediaWList)"
    #echo "$wlst"
    #echo "---------------"
    #echo "whichOnlineMediaRunning"
    #wlst="$(whichOnlineMediaRunning)"
    #echo "$wlst"
    #overkill "$@"
    #stop_it "$@"
    #echo "$0"
    #LC_ALL=C pkill --euid "$(id -u)" --exact "$@"
    #LC_ALL=C pkill -USR1 --euid "$(id -u)" --exact "$@"
    #local tmp=""
    #echo "------ tmp - no filter --------------------"
    #tmp="$(ps_ISO "$1")"
    #echo "$tmp"
    #awk '{print $3}' <<< $tmp
    #echo "------ tmp - filter $0 --------------------"
    #tmp="$(ps_ISO "$1" | grep -v "$0")"
    #echo "$tmp"
    #awk '{print $3}' <<< $tmp
    #echo "------ ps_ISO - no filter -------------------"
    #ps_ISO "$1"
    #echo "------ ps_ISO - filter $0 --------------------"
    #ps_ISO "$1" | grep -v "$0"
    #ps_ISO "$1" | grep -v "$0" | awk '{print $3}'
    #echo "--------------------------"
    #kill_them "all" "$@" "y"
    #for i in $(ps_ISO "$1" | grep -v "$0" | awk '{print $3}'); do
    #    echo "entrou i=$i"
    #    if [ "$i" != "$$" ]; then
    #        [ -n "$i" ] && proper_kill "$i"
    #        [ $? -eq 0 ] && log "Stopping instance(kill): pid=$i name=$1"
    #    fi
    #done
    #precheck xrandr
    #local lstoutdev="$(xrandr | grep 'conn' | awk '{print $1}' | sed 's/\"//g' | sed 's/\n//g')"
    #local outputDevices=( $lstoutdev )
    #local cdv="LVDS1"
    #for out in "${outputDevices[@]}" ; do
    #    [ -z "${out##*$cdv*}" ] && echo "active=$out" || echo "inactiv=$out"
    #    [ -z "${out##*LVDS1*}" ] && echo "wow active=$out"
    #done
    #lsof_p "librewolf" #| grep -v "librewolf\|/tmp\|fonts\|/proc\|/dev/pts\|/dev/tty\|/sys/dev\|xpi\|startupCache\|omni\|\.librewolf\|AppImage\|fuse\|\.mozilla"
    #lsof_p "librewolf" | grep -v "$p\|/tmp\|fonts\|/proc\|/dev/pts\|/dev/tty\|/sys/dev\|xpi\|startupCache\|omni\|\.librewolf\|AppImage\|fuse\|\.mozilla"
    #lsof_p "LibreWolf" | grep -v "/tmp\|fonts\|/proc\|/dev/pts\|/dev/tty\|/sys/dev\|xpi\|startupCache\|omni\|\.librewolf\|AppImage\|fuse\|\.mozilla"
    #uptime_active
    #psname "$@"
    hosts_up
}

main "$@"

