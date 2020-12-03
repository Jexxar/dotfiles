#!/usr/bin/env bash
#set -eu

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

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
    echo "======================================"
    yad --width 300 --title "System Logout" --image=gnome-shutdown --button="Cancel:6" --button="Lock:5" --button="Power Off:4" --button="Reboot:3" --button="Suspend:2" --button="Logout:1" --fontname="Sans bold 16" --text='<span font="26">'"    Pick up a choice"'</span>' --center --on-top --undecorated
    local yrc=$?
    echo "$yrc"
    echo "======================================"
    echo " ------ url decoding ----------"
    echo "original=V%C3%ADdeos urldecode=$(urldecode "V%C3%ADdeos")"
    echo "======================================"
    echo " ------ checkfor ----------"
    checkfor "inxi" && echo "inxi encontrado"  || echo "inxi nao encontrado"
    checkfor "firefox" && echo "firefox encontrado" || echo "firefox nao encontrado"
    echo "======================================"
    echo " ------ findutil ----------"
    echo "$(findutil inxi)"
    echo "$(findutil firefox)"
    echo "======================================"
    echo " ---- iconPath icon_name=\"error\" ----"
    local tn="$(findIconThemeName)"
    echo "findIconThemeName......: $tn"
    local tpt="$(findIconThemePath "$tn")"
    echo "findIconThemePath......: $tpt"
    ipt=$(findNrmIconHelper "$tpt" "error.svg")
    echo "from findNrmIconHelper.: $ipt"
    ipt=$(findStatIconHelper "$tpt" "error.svg")
    echo "from findStatIconHelper: $ipt"
    echo "iconPath file..........: $(iconPath "error")"
    ipt=$(FallbackiconPath "error" "$tpt")
    echo "from FallbackiconPath..: $ipt"
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
    #echo " ------ ps_ISO testing ---"
    #ps_ISO "${0##*/}" | grep "$USER" | grep -P "bash" | grep -v "grep" | awk '{print $3}'
    #ps_ISO "${0##*/}" | grep "$USER" | grep -P "bash" | grep -v "grep" | awk '{print $3}'
    echo "======================================"
    echo "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    echo "----- ps_ISO ---"
    ps_ISO "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    echo "------ kill_them  ---"
    kill_them "check" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    kill_them "sh-c" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #kill_them "strict" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    echo "======================================"
    echo "pcmanfm-qt"
    echo "----- ps_ISO ---"
    ps_ISO "pcmanfm-qt"
    echo "----- kill_them ---"
    kill_them "check" "pcmanfm-qt"
    kill_them "sh-c" "pcmanfm-qt"
    #kill_them "strict" "pcmanfm-qt"
    echo "======================================"
    echo "autoping"
    echo "----- ps_ISO ---"
    ps_ISO "autoping"
    echo "----- kill_them ---"
    kill_them "check" "autoping" "s"
    kill_them "sh-c" "autoping" "s"
    kill_them "but-me-bash" "autoping" "s"
    echo "======================================"
    echo "tilix"
    echo "----- ps_ISO ---"
    ps_ISO "tilix"
    echo "----- kill_them ---"
    kill_them "check" "tilix" "s"
    kill_them "sh-c" "tilix" "s"
    echo "======================================"
    echo "bash"
    echo "----- ps_ISO ---"
    ps_ISO "bash"
    echo "----- kill_them ---"
    kill_them "check" "bash" "s"
    echo "======================================"
    echo "firefox"
    echo "----- ps_ISO ---"
    ps_ISO "firefox"
    echo "----- kill_them ---"
    kill_them "check" "firefox" "s"
    kill_them "sh-c" "firefox" "s"
    echo "======================================"
    echo "min"
    echo "----- ps_ISO ---"
    ps_ISO "min"
    echo "----- kill_them ---"
    kill_them "check" "min" "s"
    kill_them "sh-c" "min" "s"
    #echo "======================================"
    #echo "_lsofdown"
    #_lsofdown
    #echo
    #echo "_lsof"
    #_lsof
    #echo
    echo "======================================"
    echo "lsof_p firefox"
    #ps_ISO "firefox" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "firefox" | awk '{print $1}'
    #echo "no filter"
    #lsof_p "firefox"
    #echo "filtered"
    lsof_p "firefox" | grep -v "xpi\|startupCache\|omni\|\.mozilla"
    echo "======================================"
    echo "lsof_p sublime_text"
    #ps_ISO "sublime_text" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "sublime_text" | awk '{print $1}'
    lsof_p "sublime_text"
    echo "======================================"
    echo "lsof_p pcmanfm-qt"
    #ps_ISO "pcmanfm-qt" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "pcmanfm-qt" | awk '{print $1}'
    lsof_p "pcmanfm-qt"
    echo "======================================"
    echo "lsof_p min"
    #ps_ISO "min" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "min" | awk '{print $1}'
    lsof_p "min"
    echo "======================================"
    echo "lsof_p chrome"
    #ps_ISO "chrome" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "chrome" | awk '{print $1}'
    lsof_p "chrome" | grep -v "fonts\|/proc\|/dev/pts\|omni\|chrome\|\.pki\|/sys/dev"
    echo "======================================"
    echo "lsof_p wget"
    #ps_ISO "wget" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "wget" | awk '{print $1}'
    lsof_p "wget" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    echo "======================================"
    echo "lsof_p curl"
    #ps_ISO "curl" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "curl" | awk '{print $1}'
    lsof_p "curl" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    echo "======================================"
    echo "lsof_p transmission"
    #ps_ISO "transmission" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "transmission" | awk '{print $1}'
    lsof_p "transmission" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    echo "======================================"
    echo "lsof_p nautilus"
    #ps_ISO "nautilus" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "nautilus" | awk '{print $1}'
    lsof_p "nautilus" | grep -v "nautilus-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    echo "======================================"
    echo "lsof_p caja"
    #ps_ISO "caja" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "caja" | awk '{print $1}'
    lsof_p "caja" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    echo "======================================"
    echo "lsof_p sftp"
    #ps_ISO "sftp" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "sftp" | awk '{print $1}'
    lsof_p "sftp" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    echo "======================================"
    echo "lsof_p synaptic"
    #ps_ISO "synaptic" | sed 's/bash //g' | grep -v "grep" | awk '{print $3" "$5}' | grep "synaptic" | awk '{print $1}'
    lsof_p "synaptic" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    echo "======================================"
    exit 0
}

main "$@"