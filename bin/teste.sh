#!/usr/bin/env bash
#set -eu

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

function main() {
    #grep -lIi -E "bash" * 2> /dev/null | sort -t: -${reverse}n -k 2 | while read -r line; do
    #    grep -Hi -c -E "bash" "$line";
    #done
    #local OLD_IFS=$IFS
    #IFS=$'\n'
    #for f in $(grep -lIi -E "bash" * 2> /dev/null | sort -t: -${reverse}n -k 2); do
    #    str="$(grep -Hi -c -E "bash" "$f")"
    #    echo "file: $f string: $str count: ${str##*:}"
    #done
    #IFS=$OLD_IFS
    #return 0
    precheck "dump_xsettings"
    precheck "gsettings"
    echo "$myLogPath"
    echo "$myLogFile"
    if [ $(pgrep -lfc volumeicon) -eq 0 ] && [ $(pgrep -lfc mate-volume-control-applet) -eq 0 ] ; then
        echo "dstart volumeicon" 
    else
        echo "volume ok"
    fi
    echo " ------ now logging whith tee for log files ----------"
    info "info - do some logging1 $(timestamp)"
    log "log  - do some logging1 $(timestamp)"
    info "tee  - do some logging1 $(timestamp)" | tee -a "$myLogFile" > /dev/null
    echo " ------ checkfor ----------"
    checkfor "inxi" && echo "inxi encontrado"  || echo "inxi nao encontrado"
    checkfor "firefox" && echo "firefox encontrado" || echo "firefox nao encontrado"
    echo " ------ findutil ----------"
    echo "$(findutil inxi)"
    echo "$(findutil firefox)"
    echo " ---- iconPath icon_name=\"error\" ----"
    echo "iconPath file..........: $(iconPath "error")"
    echo " ---- findIconThemeName icon_name=\"error\"---"
    local tn="$(findIconThemeName)"
    echo "icon theme name: $tn"
    local tpt="$(findIconThemePath "$tn")"
    echo "path: $tpt"
    ipt=$(findNrmIconHelper "$tpt" "error.svg")
    echo "from findNrmIconHelper file.: $ipt"
    ipt=$(findStatIconHelper "$tpt" "error.svg")
    echo "from findStatIconHelper file: $ipt"
    echo " ------ trim_spaces ---"
    echo "trim_spaces \"   example   string    \""
    trim_spaces "   example   string    "
    #ps_ISO "${0##*/}" | grep "$USER" | grep -P "bash" | grep -v "grep" | awk '{print $3}'
    #ps_ISO "${0##*/}" | grep "$USER" | grep -P "bash" | grep -v "grep" | awk '{print $3}'
    echo " ------ kill_them /usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1 ---"
    ps_ISO "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    kill_them "check" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    kill_them "sh-c" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    #kill_them "strict" "/usr/lib/x86_64-linux-gnu/polkit-mate/polkit-mate-authentication-agent-1"
    echo " ------ kill_them pcmanfm-qt ---"
    ps_ISO "pcmanfm-qt"
    kill_them "check" "pcmanfm-qt"
    kill_them "sh-c" "pcmanfm-qt"
    kill_them "strict" "pcmanfm-qt"
    echo " ------ kill_them autoping ---"
    ps_ISO "autoping"
    kill_them "check" "autoping"
    kill_them "sh-c" "autoping"
    kill_them "but-me-bash" "autoping" "s"
    echo " ------ kill_them tilix ---"
    ps_ISO "tilix"
    kill_them "check" "tilix"
    kill_them "sh-c" "tilix"
    echo " ------ kill_them bash ---"
    ps_ISO "bash"
    kill_them "check" "bash"
    echo " ------ kill_them firefox ---"
    ps_ISO "firefox"
    kill_them "sh-c" "firefox"
    #kill_them
    # while true; do
    #     echo "${0##*/}" && ps_ISO "${0##*/}" | grep "$USER"
    #     kill_them "check" "${0##*/}"
    #     kill_them "but-me-bash" "${0##*/}"
    #     snore 2
    # done
    exit 0
}

main "$@"