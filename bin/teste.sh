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
    
    #precheck "dump_xsettings"
    #precheck "gsettings"
    
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
    #echo
    #echo " ------ stopit xautolock ----------"
    #stop_it "xautolock"
    #log "enableScrXautolock(): (Re)/Starting xautolock daemon..."
    #xautolock -detectsleep -noclose -time 5 -locker "\"$HOME/bin/mylock\"" -notify 30 -notifier "\"$HOME/bin/mynotify\"" -killtime 10 -killer "\"$HOME/bin/mysuspend\"" &
    #snore 0.5
    #stop_it "xautolock"
    #echo
    echo " ------ url decoding ----------"
    echo "original=V%C3%ADdeos urldecode=$(urldecode "V%C3%ADdeos")"
    echo
    echo " ------ checkfor ----------"
    checkfor "inxi" && echo "inxi encontrado"  || echo "inxi nao encontrado"
    checkfor "firefox" && echo "firefox encontrado" || echo "firefox nao encontrado"
    echo
    echo " ------ findutil ----------"
    echo "$(findutil inxi)"
    echo "$(findutil firefox)"
    echo
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
    echo
    echo " ------ trim_spaces ---"
    echo "trim_spaces \"   example   string    \""
    trim_spaces "   example   string    "
    echo "trim \"   example   string    \""
    trim "   example   string    "
    echo "rtrim \"   example   string    \""
    rtrim "   example   string    "
    echo "ltrim \"   example   string    \""
    ltrim "   example   string    "
    echo
    #echo " ------ ps_ISO testing ---"
    #ps_ISO "${0##*/}" | grep "$USER" | grep -P "bash" | grep -v "grep" | awk '{print $3}'
    #ps_ISO "${0##*/}" | grep "$USER" | grep -P "bash" | grep -v "grep" | awk '{print $3}'
    #echo
    echo " ------ kill_them /usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1 ---"
    ps_ISO "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    kill_them "check" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    kill_them "sh-c" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #kill_them "strict" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    echo
    #echo " ------ kill_them pcmanfm-qt ---"
    #ps_ISO "pcmanfm-qt"
    #kill_them "check" "pcmanfm-qt"
    #kill_them "sh-c" "pcmanfm-qt"
    #kill_them "strict" "pcmanfm-qt"
    #echo
    echo " ------ kill_them autoping ---"
    ps_ISO "autoping"
    kill_them "check" "autoping"
    kill_them "sh-c" "autoping"
    kill_them "but-me-bash" "autoping" "s"
    echo
    echo " ------ kill_them tilix ---"
    ps_ISO "tilix"
    kill_them "check" "tilix"
    kill_them "sh-c" "tilix"
    echo
    echo " ------ kill_them bash ---"
    ps_ISO "bash"
    kill_them "check" "bash"
    echo
    echo " ------ kill_them firefox ---"
    ps_ISO "firefox"
    kill_them "sh-c" "firefox"
    echo
    echo " ------ _lsof functions ---"
    #echo "_lsofdown"
    #_lsofdown
    #echo
    #echo "_lsof"
    #_lsof
    #echo
    echo "lsof_p firefox"
    #lsof_p "firefox"
    lsof_p "firefox" | grep -v "xpi\|startupCache\|omni\|\.mozilla"
    echo
    echo "lsof_p pcmanfm-qt"
    lsof_p "pcmanfm-qt"
    echo
    echo "lsof_p chrome"
    lsof_p "chrome" | grep -v "fonts\|/proc\|/dev/pts\|omni\|chrome\|\.pki\|/sys/dev"
    echo
    echo "lsof_p wget"
    lsof_p "wget" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    echo
    echo "lsof_p curl"
    lsof_p "curl" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    echo
    echo "lsof_p transmission"
    lsof_p "transmission" | grep -v "fonts\|/proc\|/dev/pts\|/sys/dev"
    echo
    echo "lsof_p nautilus"
    lsof_p "nautilus" | grep -v "nautilus-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    echo
    echo "lsof_p caja"
    lsof_p "caja" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    echo
    echo "lsof_p sftp"
    lsof_p "sftp" | grep -v "caja-\|fonts\|/proc\|/dev/pts\|/sys/dev"
    echo
    exit 0
}

main "$@"