#!/usr/bin/env bash
# xc
# clean XC_log file
function XC_log_clean() {
    if [ -f $XC_scriptLogFile ]; then
        rm -f $XC_scriptLogFile
    fi
    touch $XC_scriptLogFile
    return 0
}

# clean state file
function XC_status_clean() {
    if [ -f $XC_scriptStateFile ]; then
        rm -f $XC_scriptStateFile
    fi
    return 0
}

# XC_log feature
function XC_log() {
    echo "["`date +%H:%M:%S`"] - " $@
    echo "["`date +%H:%M:%S`"] - " $@ >> $XC_scriptLogFile
}

#--------------------------------------
# Checks for known desktop environments
# set variable DE to the desktop environments name, lowercase

DE=""

detectDE()
{
    # see https://bugs.freedesktop.org/show_bug.cgi?id=34164
    unset GREP_OPTIONS

    if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
        case "${XDG_CURRENT_DESKTOP}" in
           # only recently added to menu-spec, pre-spec X- still in use
           Cinnamon|X-Cinnamon)
              DE=cinnamon;
              ;;
           ENLIGHTENMENT)
              DE=enlightenment;
              ;;
           # GNOME, GNOME-Classic:GNOME, or GNOME-Flashback:GNOME
           GNOME*)
              DE=gnome;
              ;;
           KDE)
              DE=kde;
              ;;
           LXDE)
              DE=lxde;
              ;;
           MATE)
              DE=mate;
              ;;
           XFCE)
              DE=xfce
              ;;
           X-Generic)
              DE=generic
              ;;
        esac
    fi

    if [ x"$DE" = x"" ]; then
        # classic fallbacks
        if [ x"$KDE_FULL_SESSION" != x"" ]; then DE=kde;
        elif [ x"$GNOME_DESKTOP_SESSION_ID" != x"" ]; then DE=gnome;
        elif [ x"$MATE_DESKTOP_SESSION_ID" != x"" ]; then DE=mate;
        elif `dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetNameOwner string:org.gnome.SessionManager > /dev/null 2>&1` ; then DE=gnome;
        elif xprop -root _DT_SAVE_MODE 2> /dev/null | grep ' = \"xfce4\"$' >/dev/null 2>&1; then DE=xfce;
        elif xprop -root 2> /dev/null | grep -i '^xfce_desktop_window' >/dev/null 2>&1; then DE=xfce
        elif echo $DESKTOP | grep -q '^Enlightenment'; then DE=enlightenment;
        fi
    fi

    if [ x"$DE" = x"" ]; then
        # fallback to checking $DESKTOP_SESSION
        case "$DESKTOP_SESSION" in
           gnome)
              DE=gnome;
              ;;
           LXDE|Lubuntu)
              DE=lxde; 
              ;;
           MATE)
              DE=mate;
              ;;
           xfce|xfce4|'Xfce Session')
              DE=xfce;
              ;;
           openbox|Openbox|OPENBOX)
              DE=openbox;
              ;;
        esac
    fi

    if [ x"$DE" = x"" ]; then
        # fallback to uname output for other platforms
        case "$(uname 2>/dev/null)" in 
            CYGWIN*)
                DE=cygwin;
                ;;
            Darwin)
                DE=darwin;
                ;;
        esac
    fi

    if [ x"$DE" = x"gnome" ]; then
        # gnome-default-applications-properties is only available in GNOME 2.x
        # but not in GNOME 3.x
        which gnome-default-applications-properties > /dev/null 2>&1  || DE="gnome3"
    fi
}

# detectDE

# echo "Desktop environment = $DE"
# Consider "xscreensaver" a separate DE
# xscreensaver-command -version 2> /dev/null | grep XScreenSaver > /dev/null && DE="xscreensaver"
# echo "Desktop environment = $DE"

# Consider "gnome-screensaver" a separate DE
# dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetNameOwner string:org.gnome.ScreenSaver > /dev/null 2>&1 && DE="gnome_screensaver"
# echo "Desktop environment = $DE"

# Consider "mate-screensaver" a separate DE
# dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetNameOwner string:org.mate.ScreenSaver > /dev/null 2>&1 && DE="mate_screensaver"
# echo "Desktop environment = $DE"

# Consider "xautolock" a separate DE
# xautolock -enable > /dev/null 2>&1 && DE="xautolock_screensaver"
# echo "Desktop environment = $DE"

# check for output connections to disable xautolock and reset screensaver
function XC_hasDelayOutputConns() {
    local oldIFS=$IFS
    local output=""
    declare -A connected_outputs
    while read line
    do
        IFS="=" read -a info <<< "$line"
        if [[ "${info[0]}" = "output" ]]; then
            output=${info[1]}
        elif [[ "${info[0]}" = "connected" && "${info[1]}" = "connected" ]]; then
            connected_outputs["${output}"]="connected"
        fi
    done < <(xrandr | sed -rn "s/^([^ ]+)[ ]+((dis)?connected)[ ]+(primary)?[ ]*([0-9]+x[0-9]+\+[0-9]+\+[0-9]+)?[ ]*.+$/output=\1\nconnected=\2\nignore=\3\nprimary=\4\nresolution=\5/p")
    IFS=$oldIFS
    for out in $XC_outputDetection; do
        if [[ ${connected_outputs["$out"]} = "connected" ]]; then
            echo "$out"
            unset connected_outputs
            return 0
        fi
    done
    echo ""
    unset connected_outputs
    return 1
}

# Detect if soundcard is being used
function XC_isSndCardBeingUsed() {
    if grep RUNNING /proc/asound/card*/pcm*/sub*/status > /dev/null; then
        XC_log "XC_isSndCardBeingUsed(): yes"
        return 0
    else
        XC_log "XC_isSndCardBeingUsed(): no"
        return 1
    fi
}

# find a running online stream
function XC_detectOnlineMedia() {
    local tmp=$(wmctrl -l 2> /dev/null | grep -i "youtube\|vimeo\|anime\|DivX\|flix\|rackle\|odcast\|cecast\|elecine\|Muu\|NetMovies")
    if [ $? -eq 0 ] ; then 
        XC_log "XC_detectOnlineMedia(): $tmp"
        return 0
    fi
    return 1
}

# find a running online stream
function XC_fullScrWinID() {
    local oldIFS=$IFS
    IFS=$'\n'
    # Loop through every display looking for a fullscreen window.
    for display in $XC_displays; do
        local allWinID=$(DISPLAY=:${display} wmctrl -l | awk '{print $1}')
        for oneWinID in $allWinID; do
            qtFullScr=$(DISPLAY=:${display} xprop -id $oneWinID 2> /dev/null | grep -c _NET_WM_STATE_FULLSCREEN)
            if [ $qtFullScr -gt 0 ] ; then 
                IFS=$oldIFS
                echo "$oneWinID"
                return 0
            fi
        done
    done
    IFS=$oldIFS
    echo ""
    return 1
}

# find a running online stream
function XC_scrAboveWinID() {
    local oldIFS=$IFS
    IFS=$'\n'
    # Loop through every display looking for a above window.
    for display in $XC_displays; do
        local allWinID=$(DISPLAY=:${display} wmctrl -l | awk '{print $1}')
        for oneWinID in $allWinID; do
            qtAboveScr=$(DISPLAY=:${display} xprop -id $oneWinID 2> /dev/null | grep -c _NET_WM_STATE_ABOVE)
            if [ $qtAboveScr -gt 0 ] ; then 
                IFS=$oldIFS
                echo "$oneWinID"
                return 0
            fi
        done
    done
    IFS=$oldIFS
    echo ""
    return 1
}

# Check if active window is matched with user settings.
# This function covers the standard way to check apps in XC_hasDelayApp
function XC_runcheck() {
    if [[ "$1" = *$2* ]]; then
        if [ "$(pidof -s $2)" ]; then
            return 0
        fi
    fi
    return 1
}

# find a delay program for a given window ID
function XC_hasDelayApp() {
    # active window ID must be passed as parameter
    if [ -z "$1" ]; then
        XC_log "XC_hasDelayApp(): Active Win ID parameter needed"
        return 1
    else
        local $winID=$1
    fi
    # Get title of active window.
    local activWinTitle=$(xprop -id $winID 2> /dev/null | grep "WM_CLASS(STRING)")
    
    # Check if user want to detect HTML5 on Chrome.
    if [[ "$activWinTitle" = *oogle-chrome* ]]; then
        # Check if Chrome process is running.
        # chrome_process=`pgrep -lfc "(c|C)hrome --type=gpu-process "
        chrome_process=$(pgrep -lfc "(c|C)hrome")
        if [[ $chrome_process -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): chrome html5 detected"
            return 0
        fi
    fi
    
    # Check if user want to detect HTML5 on Chromium.
    if [[ "$activWinTitle" == *hromium* ]]; then
        # Check if Chromium process is running.
        if [[ $(pgrep -c "chromium") -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): chromium html5 detected"
            return 0
        fi
    fi
    
    # Check if user want to detect HTML5 on Yandex browser.
    if [[ "$activWinTitle" == *andex-browser* ]]; then
        # Check if Yandex browser process is running.
        if [[ $(pgrep -c "yandex_browser") -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): Yandex browser detected"
            return 0
        fi
    fi
    
    # detect browsers that need delay screensaver
    for wapp in "${XC_delayWebBasedApps[@]}"; do
        if XC_runcheck "$activWinTitle" "$wapp" ; then
            XC_log "XC_hasDelayApp(): $wapp detected"
            return 0
        fi
    done
    
    # detect Flash on Firefox.
    if [[ "$activWinTitle" = *unknown* || "$activWinTitle" = *plugin-container* ]]; then
        # Check if plugin-container process is running.
        if [ "$(pidof -s plugin-container)" ]; then
            XC_log "XC_hasDelayApp(): firefox flash detected"
            return 0
        fi
    fi
    # detect Flash on Chromium.
    if [[ "$activWinTitle" = *exe* || "$activWinTitle" = *hromium* ]]; then
        # Check if Chromium Flash process is running.
        flash_process=$(pgrep -lfc ".*chromium.*flashp.*")
        if [[ $flash_process -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): chromium flash detected"
            return 0
        fi
    fi
    # detect Flash on Chromium.
    if [[ "$activWinTitle" = *hromium* ]]; then
        # Check if Chromium pepper Flash process is running.
        chromium_process=$(pgrep -lfc "chromium(|-browser) --type=ppapi ")
        if [[ $chromium_process -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): chromium pepper flash detected"
            return 0
        fi
    fi
    # detect Flash on Chrome.
    if [[ "$activWinTitle" = *oogle-chrome* ]]; then
        # Check if Chrome pepper Flash process is running.
        chrome_process=$(pgrep -lfc "(c|C)hrome --type=ppapi ")
        if [[ $chrome_process -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): chrome flash detected"
            return 0
        fi
    fi
    # detect Flash on Opera.
    if [[ "$activWinTitle" = *operapluginwrapper* ]]; then
        # Check if Opera flash process is running.
        flash_process=$(pgrep -lfc operapluginwrapper-native)
        if [[ $flash_process -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): opera flash detected"
            return 0
        fi
    fi
    # detect Flash on WebKit.
    if [[ "$activWinTitle" = *WebKitPluginProcess* ]]; then
        # Check if WebKit Flash process is running.
        flash_process=$(pgrep -lfc ".*WebKitPluginProcess.*flashp.*")
        if [[ $flash_process -ge 1 ]]; then
            XC_log "XC_hasDelayApp(): webkit flash detected"
            return 0
        fi
    fi
    # detect MPlayer 
    if [[ "$activWinTitle" = *mplayer* || "$activWinTitle" = *MPlayer* ]]; then
        # Check if MPlayer is running.
        if [ "$(pidof -s mplayer)" ]; then
            XC_log "XC_hasDelayApp(): mplayer detected"
            return 0
        fi
    fi

    # detect programs that need delay screensaver
    for prog in "${XC_delayApps[@]}"; do
        if XC_runcheck "$activWinTitle" "$prog" ; then
            XC_log "XC_hasDelayApp(): $prog fullscreen detected"
            return 0
        fi
    done

    XC_log "XC_hasDelayApp(): No application fullscreen detected"
    return 1
}

# check for fullscreen or above screen that set to trigger the delay
function XC_isFullScreenBeingUsed() {
    local activWinFullscreenID=$(XC_fullScrWinID)
    if [ -z $activWinFullscreenID ]; then
        XC_log "XC_isFullScreenBeingUsed(): NO fullscreen detected"
        local activWinAboveID=$(XC_scrAboveWinID)
        if [ -z $activWinAboveID ]; then 
            XC_log "XC_isFullScreenBeingUsed(): NO above screen detected"
            return 1
        else
            local activeWinID=$activWinAboveID
        fi
    else
        local activeWinID=$activWinFullscreenID
    fi
    
    # Above state is used in some window managers instead of fullscreen.
    # if we reach this part at least one window id was found
    XC_log "XC_isFullScreenBeingUsed(): active Win ID=$activeWinID"
    
    if XC_detectOnlineMedia; then 
        XC_log "XC_isFullScreenBeingUsed(): Fullscreen detected: streaming is running..."
        return 0
    fi
    if XC_hasDelayApp $activeWinID; then 
        XC_log "XC_isFullScreenBeingUsed(): Fullscreen detected: the app is set to trigger the delay"
        return 0
    fi
    
    XC_log "XC_isFullScreenBeingUsed(): Fullscreen detected: the app is UNKNOWN or NOT set to trigger the delay"
    return 1
}

# Find a screensaver process running
function XC_whichScrSvrRunning() {
    if [ $XC_xautolockPresent -eq 1 ]; then
        local tmp=$(pgrep -lfc xautolock)
        [ $tmp -gt 0 ] && echo "xautolock"
        return 0
    fi
    if [ $XC_gnomeScrSvrPresent -eq 1 ]; then
        local tmp=$(pgrep -lfc gnome-screensaver)
        [ $tmp -gt 0 ] && echo "gnome-screensaver"
        return 0
    fi
    if [ $XC_mateScrSvrPresent -eq 1 ]; then
        local tmp=$(pgrep -lfc mate-screensaver)
        [ $tmp -gt 0 ] && echo "mate-screensaver"
        return 0
    fi
    if [ $XC_cinnamonScrSvrPresent -eq 1 ]; then
        local tmp=$(pgrep -lfc cinnamon-screensaver)
        [ $tmp -gt 0 ] && echo "cinnamon-screensaver"
        return 0
    fi
    if [ $XC_xScrSvrPresent -eq 1 ]; then
        local tmp=$(pgrep -lfc xscreensaver)
        [ $tmp -gt 0 ] && echo "xscreensaver"
        return 0
    fi
    if [ $XC_xdgScrSvrPresent -eq 1 ]; then
        local tmp=$(pgrep -lfc xdg-screensaver)
        [ $tmp -gt 0 ] && echo "xdg-screensaver"
        return 0
    fi
    echo ""
    return 0
}

# mostra nome do processo
function XC_pname() {
    ps -p $1 -o comm=
    if [ $? -ne 0 ]; then
        echo ""
    fi
}

# only one instance of this job
function XC_kill_older() {
    local bf_proc=( $(ps -aux | grep "$XC_scriptName" | egrep -v 'grep' | sort -u | awk '{print $1"_"$2"_"$9}') )
    local ko_done=false
    local bf_len=${#bf_proc[@]}
    let bf_len=bf_len-1
    local aux=""
    local pc_id="0"
    local i="0"
    local mypid=$$
    local pnm=$(XC_pname $mypid)
    echo "bf_proc:"
    echo ${bf_proc[@]}
    echo ""
    echo ""
    echo "script_name = $XC_scriptName"
    echo ""
    echo "mypid = $mypid process name = $pnm"
    for i in $(seq 0 $bf_len ); do 
        aux=$(echo "${bf_proc[$i]}" | sed -e "s/_/ /g");
        echo "aux = $aux";
        pc_id=$(echo $aux | awk '{print $2}');
        pnm=$(XC_pname $pc_id)
        echo "elem $i : ${bf_proc[$i]}  pc_id=$pc_id  pc_nm=$pnm "
        if [ "$pc_id" != "$mypid" ] && [ "$pnm" == "$XC_scriptName" ]; then
            echo "ia dar kill em $pc_id > /dev/null"
        fi
    done
    return 0
}

# find a mandatory in fullscreen mode
function XC_hasMandatoryDelay() {
    local tmp="0"
    for p1 in "${XC_mandDelayApps[@]}"; do
        tmp=$(pgrep -lc "${p1}")
        if [ $tmp -gt 0 ] ; then
            XC_log "XC_hasMandatoryDelay(): mandatory delay program $p1 found..."
            return 0
        fi
    done
    return 1
}

# check for delay programs to disable xautolock and reset screensaver
function XC_delayXautolock() {
    # disable xautolock if mandatory delay progs were found
    if XC_hasMandatoryDelay; then 
        XC_log "XC_delayXautolock(): Delaying the screensaver because a mandatory delay program is running..."
        XC_disableScrXautolock 
        return 0
    else
        XC_log "XC_delayXautolock(): No mandatory delay programs were found..."
    fi

    # disable xautolock if delay progs are playing (using sound card)
    if XC_isSndCardBeingUsed; then 
        local progName=$(XC_detectUsingPulseaudio)
        if [ ! -z "$progName" ]; then 
            XC_log "XC_delayXautolock(): Delaying the screensaver because a delay program (or stream), \"$progName\", is running..."
            XC_disableScrXautolock 
            return 0
        else
            XC_log "XC_delayXautolock(): No delay program (or stream) using sound card is running..."
        fi
    fi

    # disable xautolock if delay progs are in fullscreen mode
    if XC_isFullScreenBeingUsed; then 
        XC_log "XC_delayXautolock(): Delaying the screensaver because a Fullscreen delay program is running..."
        XC_disableScrXautolock 
        return 0
    else
        XC_log "XC_delayXautolock(): No delay program (or stream) in Fullscreen mode is running..."
    fi

    # disable xautolock if we have significant ouput connections
    if XC_hasDelayOutputConns; then 
        XC_log "XC_delayXautolock(): Delaying the screensaver because significant Output connections were found..."
        XC_disableScrXautolock 
        return 0
    else
        XC_log "XC_delayXautolock(): No delay output connections detected..."
    fi

    XC_log "XC_delayXautolock(): No delay programs were detected for suspending screensaver..."

    #-----------------------------------------
    # Since no delay situations were detected we must enable screensaver if necessary
    #-----------------------------------------
    local stt=$(XC_read_state)

    XC_log "XC_delayXautolock(): Current xautolock state = $stt "
    
    if [ "$stt" == "disabled" ]; then
        XC_enableScrXautolock 
        XC_log "XC_delayXautolock(): xautolock screensaver enabled..."
        return 0
    fi
}

#------------------------------------------------------------------------------
# parse the ini like $0.$host_name.cnf and set the variables
# cleans the unneeded during after run-time stuff. Note the MainSection
# courtesy of : http://mark.aufflick.com/blog/2007/11/08/parsing-ini-files-with-sed
#------------------------------------------------------------------------------
XC_parseConfFile(){
    # set a default cnfiguration file
    local confFile="$XC_scriptConfDir/$XC_scriptConfFile"
    local tmp_dir="/tmp"

    test -z "$1" || ini_section=$1;
    XC_log "DEBUG read configuration file : $confFile"
    XC_log "INFO read [$ini_section] section from config file"

    # debug echo "@doParseConfFile confFile:: $confFile"
    # coud be later on parametrized ...
    test -z "$ini_section" && ini_section='MAIN_SETTINGS'

    XC_log "DEBUG reading: the following configuration file"
    XC_log "DEBUG ""$confFile"
    ( set -o posix ; set ) | sort >"$tmp_dir/vars.before"

    eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/#.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
        < $confFile \
        | sed -n -e "/^\[$ini_section\]/,/^\s*\[/{/^[^#].*\=.*/p;}"`

    ( set -o posix ; set ) | sort >"$tmp_dir/vars.after"

    XC_log "INFO added the following vars from section: [$ini_section]"
    local cmd="$(comm -3 $tmp_dir/vars.before $tmp_dir/vars.after | perl -ne 's#\s+##g;print "\n $_ "' )"
    echo -e "$cmd"
    echo -e "$cmd" >> $XC_scriptLogFile
    echo -e "\n\n"
    #sleep 1; printf "\033[2J";printf "\033[0;0H" # and clear the screen
}

#------------------------------------------------------------------------------
function XC_contentConfFile(){
    local ini_section=""
    test -z "$1" || ini_section=$1;
    local CFG_FILE="$XC_scriptConfDir/$XC_scriptConfFile"
    #cat "$CFG_FILE"
    echo ""
    echo "$ini_section"
    echo ""
    #local CFG_CONTENT=$(cat $CFG_FILE | sed -r '/[^=]+=[^=]+/!d' | sed -r 's/\s+=\s/=/g')
    local CFG_CONTENT=$(cat $CFG_FILE | sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/#.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" | sed -n -e "/^\[$ini_section\]/,/^\s*\[/{/^[^#].*\=.*/p;}")
    #eval "$CFG_CONTENT"
    echo "$CFG_CONTENT"
}


#------------------------------------------------------------------------------
function XC_otherContentConfFile(){
    local CFG_FILE="$XC_scriptConfDir/$XC_scriptConfFile"
    cat $CFG_FILE | while read line
    do 
        IFS='=' read -a myarray <<< "$line"
        #echo "line = $line"
        #echo ${myarray[@]}
        echo "${myarray[0]} == ${myarray[1]}"
    done
}

#------------------------------------------------------------------------------
function XC_doParseConfFile(){
    local conf_file="$XC_scriptConfDir/$XC_scriptConfFile"
    echo " Reading configuration file $conf_file "
    
    while IFS= read -r line; do
      line=${line%%#*}
      case $line in
        *=*)
            var=${line%%=*}
            case $var in
                *[!A-Z_a-z]*)
                    echo "Warning: invalid variable name $var ignored" >&2
                    continue;;
            esac
            if eval '[ -n "${'$var'+1}" ]'; then
                echo "Warning: variable $var already set, redefinition ignored" >&2
                continue
            fi
            line=${line#*=}
            eval $var='"$line"'
      esac
    done <"$conf_file"
    
    echo "Current values after reading configuration file"
    
    echo "width $width"
    echo "height $height"
    echo "sinkInputType $sinkInputType"
    echo "sourceOutputType $sourceOutputType"
    echo "sinkType $sinkType"
    echo "sourceType $sourceType"
    #echo "mandatoryApps ${mandatoryApps[@]}"
    
    for i in "${mandatoryApps[@]}"; do
        local arr=( $(echo "$i" | sed -e 's/(//g' | sed -e 's/)//g') )
        for el in "${arr[@]}"; do
            echo "[] = $el"
        done
    done

    echo "delayApps ${delayApps[@]}"
    echo "webBasedApps ${webBasedApps[@]}"
   
    return 0
}

XC_activWinID="0"
# Names of programs which, when running, you wish to delay the screensaver.
# For example ('ardour2' 'gmpc').
XC_mandDelayApps=('wineserver' 'dbgl' 'dgen' 'lutris' 'playonlinux' 'avidemux' 'clipgrab' 'scummvm' 'flare' 'frozen-bubble' '0ad' 'TeamViewer' 'remmina' 'dosbox' 'wine')

# Names of programs which, when running, you wish to delay the screensaver.
# For example ('ardour2' 'gmpc').
XC_delayApps=('vlc' 'xplayer' 'bino' 'curlew' 'avidemux' 'mpv' 'smplayer' 'smtube' 'gmpc' 'ardour2' 'xine' 'totem' 'parole' 'qmmp' 'kaffeine' 'kmplayer' 'kdenlive' 'ffmpeg')

# Names of programs which, when using sound server, you wish to delay the screensaver.
XC_delayWebBasedApps=('chrome' 'firefox' 'opera' 'Iceweasel' 'WebKit' 'vivaldi' 'brave' 'chromium' 'epiphany' 'youtube-dl' 'smtube' 'midori' 'min' 'falkon' 'slimjet' 'steam')

# enumerate all the attached screens
XC_displays=$(xvinfo | awk -F'#' '/^screen/ {print $2}' | xargs)

XC_xautolockPresent=$(if [ -x $(which xautolock) ]; then echo 1; else echo 0; fi)
XC_gsettingsPresent=$(if [ -x $(which gsettings) ]; then echo 1; else echo 0; fi)
XC_xdgScrSvrPresent=$(if [ -x $(which xdg-screensaver) ]; then echo 1; else echo 0; fi)
XC_mateScrSvrPresent=$(if [ -x $(which mate-screensaver) ]; then echo 1; else echo 0; fi)
XC_gnomeScrSvrPresent=$(if [ -x $(which gnome-screensaver) ]; then echo 1; else echo 0; fi)
XC_cinnamonScrSvrPresent=$(if [ -x $(which cinnamon-screensaver) ]; then echo 1; else echo 0; fi)
XC_xScrSvrPresent=$(if [ -x $(which xscreensaver) ]; then echo 1; else echo 0; fi)

XC_outputDetection="HDMI1"


XC_scriptName="${0##*/}"
XC_scriptBaseName="${XC_scriptName%%.*}"
XC_scriptFPath="$(dirname $(readlink -f $0))/${XC_scriptName}"
XC_scriptConfDir="$HOME/.config/${XC_scriptBaseName}"
XC_scriptConfFile="${XC_scriptBaseName}.conf"
XC_scriptLogFile="/var/log/${XC_scriptBaseName}.log"

echo ""
echo ""

# XC_kill_older

echo ""
echo ""
echo "XC_scriptName     = $XC_scriptName"
echo "XC_scriptBaseName = $XC_scriptBaseName"
echo "XC_scriptFPath    = $XC_scriptFPath"
echo "XC_scriptConfDir  = $XC_scriptConfDir"
echo "XC_scriptConfFile = $XC_scriptConfFile"
echo "path to conf      = $XC_scriptConfDir/$XC_scriptConfFile"
echo "XC_scriptLogFile  = $XC_scriptLogFile"
echo ""
echo ""

echo ""
echo ""


if XC_hasDelayOutputConns; then 
    XC_log "Delaying the screensaver because an output device..."
else
    XC_log "No delay output device found..."
fi

echo ""
echo ""

XC_log "XC_winIDFullScr == $(XC_fullScrWinID)"
XC_log "XC_winAboveScr == $(XC_scrAboveWinID)"

#if XC_detectOnlineMedia; then 
#    XC_log "Media program is running..."
#else
#    XC_log "No Media program (or stream) is running..."
#fi

if XC_isFullScreenBeingUsed; then 
    XC_log "Delaying the screensaver because a Fullscreen delay program is running..."
else
    XC_log "No delay program (or stream) in Fullscreen mode is running..."
fi

#echo "Screensaver XC_xautolockPresent  = $XC_xautolockPresent"
#echo "Screensaver XC_gsettingsPresent  = $XC_gsettingsPresent"
#echo "Screensaver XC_xdgScrSvrPresent  = $XC_xdgScrSvrPresent"
#echo "Screensaver XC_mateScrSvrPresent  = $XC_mateScrSvrPresent"
#echo "Screensaver XC_gnomeScrSvrPresent  = $XC_gnomeScrSvrPresent"
#echo "Screensaver XC_cinnamonScrSvrPresent  = $XC_cinnamonScrSvrPresent"
#echo "Screensaver XC_xScrSvrPresent  = $XC_xScrSvrPresent"

#XC_parseConfFile window

echo ""
echo ""

#XC_contentConfFile window
#XC_contentConfFile MAIN_SETTINGS
#XC_doParseConfFile

#XC_otherContentConfFile

#scrsvr=$(XC_whichScrSvrRunning)

#echo "esta rodando o ${scrsvr}"

#if [ "$(XC_whichScrSvrRunning)" = "xautolock" ]; then 
#    echo "ta rodando mesmo o xautolock daemon..."
#fi



