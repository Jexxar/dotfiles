#!/bin/bash

# pipeSysInfo

# call from .config/openbox/menu.xml like
#        <menu id="sysInfo" label="sysInfo" execute="pipeSysInfo pipe" />

# or from cli: pypeSysinfo

# required awk, bc, inxi

COMMON_FUNCTIONS="$HOME/.config/openbox/scripts/pipe-common.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    . "${COMMON_FUNCTIONS}" 2> /dev/null
else
    echo $"Error: Failed to locate $COMMON_FUNCTIONS" >&2
    exit 1
fi

function doAudioCard() {
    local tmp=$(inxi -A -c0 | grep 'Card' | sed 's/Card/!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | sed 's/ driver:/!driver:/g')
    tmp=${tmp%!*}
    echo "$tmp" | tr -s '[:blank:]'''
}

function doAudioCardDriver() {
    inxi -A -c0 | grep 'Card' | sed 's/driver:/!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" 
}

function doAudioVol() {
    if amixer get Master | grep -q 'Right'
    then
        amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | tr -d '[]%'
    else
        awk -F"[][]" '/%/ { print $2 }' <(amixer sget Master)  | tr -d '[]%'
    fi
}

function doAdapter() {
    acpi -a | grep "Adapter" | cut -f 2 -d':' | sed 's/\n//g' | sed "s/^[ \t]*//"
}

function doBrightness(){
    local ab=$(cat /sys/class/backlight/intel_backlight/actual_brightness);
    local mb=$(cat /sys/class/backlight/intel_backlight/max_brightness);
    echo "$ab/$mb*100" | bc;
}

function doBatteryPerc() {
    acpi -b | grep "Battery" | cut -f 2 -d':' | awk '{print $2}'
}

function doCPU() {
    cat /proc/cpuinfo | grep 'model name' | cut -f 2 -d':' | uniq
}

function doCPUUsage() {
    local tmp=$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc)
    tmp=$(awk_round 0 "$tmp")
    echo "$tmp%"
}

function doDriveHDD() {
    inxi -d -c0 | grep 'HDD' | sed 's/(/!(/g' | sed 's,.*!,,' | sed 's/ID-1://g' | sed 's/(//g' | sed 's/)//g' | sed "s/^[ \t]*//" | awk '{print $3, $5, $7, $1}'
}

function doDriveOptical() {
    inxi -d -c0 | grep 'Optical' | sed 's/Optical:/Optical:!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | awk '{print $1,$3,$4,$5}'
}

function doDriveUU() {
    local d=${1}
    [ -z $d ] && d=$PWD
    local dv=$(df -h $d | awk 'NR==2 {print $1}')
    d=$(df -h $d | awk 'NR==2 {print $6}')
    local dus=$(inxi -pu -c0 | grep "$dv" | sed 's/size:/!size:/g' | sed 's,.*!,,' | awk '{print $9,$7,$2,$4,$5}')
    local ui=$(cat /etc/fstab | grep "$d " | grep "UUID" | sed 's/UUID=/UUID=!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | awk '{print $1}')
    echo "$ui $dus"
}

function doGraphicCard() {
    inxi -G -c0 | awk '/Card/ {print $3, $4, $5, $6, $7}'
}

function doGraphicServer() {
    inxi -G -c0 | awk '/Server/ {print $3, $4 " / " $5, $6}'
}

function doGraphicRenderer() {
    inxi -G -c0 | awk '/Renderer/ {print $3, $12 " / " $4, $5, $6, $7 " / " $8, $10}'
}

function doDE() {
    inxi -S -c0 | awk '/Desktop/ {print $10, $11}'
}

function doLoad() {
    local tmp=$(uptime | awk '{print $10}' | cut -d ',' -f 1-2 | sed 's/\,/\./g');
    tmp=$(echo "$tmp * 100" | bc)
    awk_round 0 "$tmp"
}
    
function doMachine() {
    inxi -M -c0 | awk '{print $3, $5, $6, $7, $9}'
}

function doNetWANIP() {
    inxi -i -c0 | awk '/WAN IP/ {print $3}'
}

function doNetCard1() {
    inxi -i -c0 | grep 'Card-1' | sed 's/Card-1:/!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | sed 's/driver:/\/ driver:/g'
}

function doNetCard2() {
    inxi -i -c0 | grep 'Card-2' | sed 's/Card-2:/!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | sed 's/driver:/\/ driver:/g'
}

function doNetWifiIF() {
    nmcli device status | awk '/wifi/ {print $1}'
}

function doNetWifiSSID() {
    nmcli device status | awk '/wifi/ {print $4}'
}

function doNetWifiStatus() {
    nmcli device status | awk '/wifi/ {print $3}'
}

function doNetWiredIF() {
    nmcli device status | awk '/ethernet/ {print $1}'
}

function doNetWiredStatus() {
    nmcli device status | awk '/ethernet/ {print $3}'
}

function doNetWifiPerf() {
    local tmp=$(nmcli device status | awk '/wifi/ {print $4}')
    nmcli dev wifi | grep $tmp | grep "Mbit/s" | tr -s '[:blank:]''' | cut -d ' ' -f 3-9 | awk '{print $1,$2,$3 " Mb",$5"%",$7}'
}

function doNetIPv4() {
    ifconfig -a | grep "inet " | grep -v 127 | cut -d ' ' -f 1-14 | awk '{print $3}'
}

function doNetIPv6() {
    ifconfig -a | grep "inet6" | grep -v "::1" | cut -d ' ' -f 1-14 | awk '{print $3}'
}

function doProc() {
    inxi -I -c0 | awk '/Processes/ {print $3}'
}

function doMemAvail() {
    free -m | sed -n '2,2p' | tr -s '[:blank:]''' | cut -f 7 -d' '
}

function doMemFree() {
    free -m | awk 'NR==2{print ($2-$4)"M"}'
}

function doMemTotal() {
    free -m | awk 'NR==2{print $2"M"}'
}

function doFreeSwap() {
    free -m | sed -n '3,3p' | tr -s '[:blank:]''' | cut -f 4 -d' '
}

function doMemSummary() {
    read -r memslash mem <<< $(free -m | awk 'NR==2{printf "%s/%sM %.0f%%", ($2-$4),$2,($2-$4)*100/$2 }')
    local mem="${mem//%}"
    echo "$mem"
}

function doUptime() {
    uptime -p | sed 's/days/d/g' | sed 's/day/d/g' | sed 's/hours/h/g' |  sed 's/hour/h/g' |  sed 's/minutes/m/g' |  sed 's/minute/m/g' |  sed 's/up //g'
}

function doServerMan() {
    cat /proc/1/comm | awk '{print $1}'
}

function doResolution() {
    inxi -G -c0 | grep Resolution  | awk '{print $8}'
}

function doTemperature() {
    local tmp=$(acpi -t | grep 'Thermal' | awk 'NR==1 {print $4}')
    tmp=$(awk_round 0 "$tmp")
    echo "$tmp C" | awk '{print $1""$2}'
}

function doSwappiness() {
    cat /proc/sys/vm/swappiness | sed "s/^[ \t]*//"
}

function doWeather() {
    ${HOME}/bin/weather
}

function doDistro() {
    ${HOME}/bin/distro_info -3 | tr -s '[:blank:]'''
}

function doHost() {
    uname -n
}

function doOS() {
    uname -o
}

function doArch() {
    uname -m | sed 's/_/-/g'
}

function doKernel() {
    uname -r
}

function doMenu() {
    # l10n support
    case "${LANG:-}" in
        de_* ) doMenu_en ;; # Deutsch
        da_* ) doMenu_en ;; # Danish
        es_* ) doMenu_en ;; # Española
        fr_* ) doMenu_en ;; # Français
        id_* ) doMenu_en ;; # Bahasa Indonesia
        it_* ) doMenu_en ;; # Italian
        lv_* ) doMenu_en ;; # Latvian
        pl_* ) doMenu_en ;; # Polish
        pt_* ) doMenu_en ;; # Português
        ru_* ) doMenu_en ;; # Russian
        * ) doMenu_en ;; # Default to English
    esac
}

function doMenu_en() {
    menuBegin
    menuSep 

    # -------------------------------------------------------------------
    # Audio Card
    # -------------------------------------------------------------------
    local auc=$(doAudioCard);

    menuItem "Audio Card: $auc"
    
    # -------------------------------------------------------------------
    # Audio Card Driver
    # -------------------------------------------------------------------
    local aud=$(doAudioCardDriver);

    menuItem "Audio Card Driver: $aud"
    
    # -------------------------------------------------------------------
    # Audio Vol
    # -------------------------------------------------------------------
    local avl=$(doAudioVol);

    menuItem "Volume: $avl%"

    # -------------------------------------------------------------------
    # Distro 
    # -------------------------------------------------------------------
    local dis=$(doDistro);
    menuItem "Distro: $dis"
    
    # -------------------------------------------------------------------
    # Host 
    # -------------------------------------------------------------------
    local hst=$(doHost);
    menuItem "Host: $hst"
    
    # -------------------------------------------------------------------
    # OS 
    # -------------------------------------------------------------------
    local os=$(doOS);
    menuItem "OS: $os"
    
    # -------------------------------------------------------------------
    # Architecture 
    # -------------------------------------------------------------------
    local arc=$(doArch);
    menuItem "Architecture: $arc"
    
    # -------------------------------------------------------------------
    # Kernel 
    # -------------------------------------------------------------------
    local krn=$(doKernel);
    menuItem "Kernel: $krn"
    
    # -------------------------------------------------------------------
    # Service Manager
    # -------------------------------------------------------------------
    local svm=$(doServerMan);
    menuItem "Service Manager: $svm"
    
    # -------------------------------------------------------------------
    # Adapter 
    # -------------------------------------------------------------------
    local adp=$(doAdapter);
    menuItem "Adapter: $adp"
    
    # -------------------------------------------------------------------
    # Battery 
    # -------------------------------------------------------------------
    local btp=$(doBatteryPerc);
    menuItem "Battery: $btp"
    
    # -------------------------------------------------------------------
    # Brightness 
    # -------------------------------------------------------------------
    local bgh=$(doBrightness);
    menuItem "Brightness: $bgh"
    
    # -------------------------------------------------------------------
    # Load 
    # -------------------------------------------------------------------
    local lod=$(doLoad);
    menuItem "Load: $lod%"
    
    # -------------------------------------------------------------------
    # Memory 
    # -------------------------------------------------------------------
    local mav=$(doMemAvail);
    menuItem "Memory: Available $mav"
    
    # -------------------------------------------------------------------
    # Swap 
    # -------------------------------------------------------------------
    local fsw=$(doFreeSwap);
    menuItem "Free Swap: $fsw"
    
    # -------------------------------------------------------------------
    # Swappiness 
    # -------------------------------------------------------------------
    local swp=$(doSwappiness);
    menuItem "Swappiness: $swp"
    
    # -------------------------------------------------------------------
    # Memory (summary) 
    # -------------------------------------------------------------------
    local msu=$(doMemSummary);
    menuItem "Memory (summary): $msu%"
        
    # -------------------------------------------------------------------
    # Resolution
    # -------------------------------------------------------------------
    local rsl=$(doResolution);
    menuItem "Resolution: $rsl"
    
    # -------------------------------------------------------------------
    # Thermal 
    # -------------------------------------------------------------------
    local thm=$(doTemperature);
    menuItem "Temperature: $thm"
    
    # -------------------------------------------------------------------
    # Time 
    # -------------------------------------------------------------------
    local tdt=$(date +"%d-%m-%Y, %R");
    menuItem "Time: $tdt"
    
    # -------------------------------------------------------------------
    # Uptime 
    # -------------------------------------------------------------------
    local upt=$(doUptime);
    menuItem "Uptime: $upt"
    
    # -------------------------------------------------------------------
    # WiFi Interface 
    # -------------------------------------------------------------------
    local wif=$(doNetWifiIF);
    menuItem "WiFi Interface: $wif"
    
    # -------------------------------------------------------------------
    # WiFi SSID 
    # -------------------------------------------------------------------
    local wss=$(doNetWifiSSID);
    menuItem "WiFi SSID: $wss"
    
    # -------------------------------------------------------------------
    # WiFi Status 
    # -------------------------------------------------------------------
    local wst=$(doNetWifiStatus);
    menuItem "WiFi Status: $wst"
    
    # -------------------------------------------------------------------
    # WiFi Performance
    # -------------------------------------------------------------------
    local wfp=$(doNetWifiPerf);
    menuItem "WiFi Performance: $wfp"
    
    # -------------------------------------------------------------------
    # Local IPv4 
    # -------------------------------------------------------------------
    local ip4=$(doNetIPv4);
    menuItem "Local IPv4: $ip4"
    
    # -------------------------------------------------------------------
    # WiFi Inet6 
    # -------------------------------------------------------------------
    local ip6=$(doNetIPv6);
    menuItem "Local IPv6: $ip6"
    
    # -------------------------------------------------------------------
    # Wired Interface
    # -------------------------------------------------------------------
    local eif=$(doNetWiredIF);
    menuItem "Wired Interface: $eif"
    
    # -------------------------------------------------------------------
    # Wired Status
    # -------------------------------------------------------------------
    local est=$(doNetWiredStatus);
    menuItem "Wired Status: $est"
    
    # -------------------------------------------------------------------
    # CPU description
    # -------------------------------------------------------------------
    local cpd=$(doCPU);
    menuItem "CPU description: $cpd"

    # -------------------------------------------------------------------
    # CPU usage in percents 
    # -------------------------------------------------------------------
    local cpu=$(doCPUUsage);
    menuItem "CPU usage: $cpu"
    
    # -------------------------------------------------------------------
    # Memory summary
    # -------------------------------------------------------------------
    local mus=$(doMemSummary);
    menuItem "Memory summary: $mus%"
    
    # -------------------------------------------------------------------
    # /home disk usage in percents and free space in Gb (32% used, 65G free)
    # -------------------------------------------------------------------
    local hdk=$(doDriveUU "$HOME");
    menuItem "$HOME $hdk" 
    
    # -------------------------------------------------------------------
    # / disk usage in percents and free space in Gb (32% used, 65G free)
    # -------------------------------------------------------------------
    local rdk=$(doDriveUU "/ ");
    menuItem "/ $rdk" 

    # -------------------------------------------------------------------
    # Machine Info
    # -------------------------------------------------------------------
    local mci=$(doMachine);
    menuItem "Machine Info: $mci"

    # -------------------------------------------------------------------
    # Process Summary
    # -------------------------------------------------------------------
    #local prc=$(doProc);
    #menuItem "Process Summary: $prc"
        
    menuEnd
}

function doMenu_pt() {
    menuBegin
    menuSep 
    menuItem 'Audio' '~/.config/openbox/scripts/inxi-pipemenu Audio'
    #menuItem 'Battery' '~/.config/openbox/scripts/inxi-pipemenu Battery'
    menuItem 'CPU' '~/.config/openbox/scripts/inxi-pipemenu CPU'
    menuItem 'Discos Info' '~/.config/openbox/scripts/inxi-pipemenu DrivesGI'
    menuItem 'Uso UUID' '~/.config/openbox/scripts/inxi-pipemenu DrivesUU'
    menuItem 'Não Montado' '~/.config/openbox/scripts/inxi-pipemenu DrivesUN'
    menuItem 'Graficos' '~/.config/openbox/scripts/inxi-pipemenu Graphics'
    menuItem 'Host' '~/.config/openbox/scripts/inxi-pipemenu HostKBD'
    menuItem 'Máquina' '~/.config/openbox/scripts/inxi-pipemenu MachineInfo'
    menuItem 'Rede' '~/.config/openbox/scripts/inxi-pipemenu Network'
    menuItem 'Processos' '~/.config/openbox/scripts/inxi-pipemenu Processes'
    menuItem 'Sumario' '~/.config/openbox/scripts/inxi-pipemenu ProcUptimeMemory'
    menuItem 'Repositórios' '~/.config/openbox/scripts/inxi-pipemenu Repositories'
    menuItem 'Resolução' '~/.config/openbox/scripts/inxi-pipemenu Resolution'
    menuItem 'Temperatura' '~/.config/openbox/scripts/inxi-pipemenu Temperature'
    menuItem 'Clima' '~/.config/openbox/scripts/inxi-pipemenu Weather'
    menuEnd
}

function doCli() {
    # -------------------------------------------------------------------
    # Audio Card
    # -------------------------------------------------------------------
    local auc=$(doAudioCard);
    echo "Audio Card = $auc"

    # -------------------------------------------------------------------
    # Audio Card Driver
    # -------------------------------------------------------------------
    local aud=$(doAudioCardDriver);
    echo "Audio Card Driver = $aud"

    # -------------------------------------------------------------------
    # Audio Vol
    # -------------------------------------------------------------------
    local avl=$(doAudioVol);
    echo "Audio Vol = $avl%"

    # -------------------------------------------------------------------
    # Distro 
    # -------------------------------------------------------------------
    local dis=$(doDistro);
    echo "Distro = $dis"
    
    # -------------------------------------------------------------------
    # Host 
    # -------------------------------------------------------------------
    local hst=$(doHost);
    echo "Host = $hst"
    
    # -------------------------------------------------------------------
    # OS 
    # -------------------------------------------------------------------
    local os=$(doOS);
    echo "OS = $os"
    
    # -------------------------------------------------------------------
    # Architecture 
    # -------------------------------------------------------------------
    local arc=$(doArch);
    echo "Architecture = $arc"
    
    # -------------------------------------------------------------------
    # Kernel 
    # -------------------------------------------------------------------
    local krn=$(doKernel);
    echo "Kernel = $krn"
    
    # -------------------------------------------------------------------
    # Service Manager
    # -------------------------------------------------------------------
    local svm=$(doServerMan);
    echo "Service Manager = $svm"
    
    # -------------------------------------------------------------------
    # Adapter 
    # -------------------------------------------------------------------
    local adp=$(doAdapter);
    echo "Adapter = $adp"
    
    # -------------------------------------------------------------------
    # Battery 
    # -------------------------------------------------------------------
    local btp=$(doBatteryPerc);
    echo "Battery = $btp"
    
    # -------------------------------------------------------------------
    # Brightness 
    # -------------------------------------------------------------------
    local bgh=$(doBrightness);
    echo "Brightness = $bgh"
    
    # -------------------------------------------------------------------
    # Load 
    # -------------------------------------------------------------------
    local lod=$(doLoad);
    echo "Load = $lod"
    
    # -------------------------------------------------------------------
    # Memory 
    # -------------------------------------------------------------------
    local mav=$(doMemAvail);
    echo "Memory = $mav"
    
    # -------------------------------------------------------------------
    # Swap 
    # -------------------------------------------------------------------
    local fsw=$(doFreeSwap);
    echo "Swap = $fsw"
    
    # -------------------------------------------------------------------
    # Swappiness 
    # -------------------------------------------------------------------
    local swp=$(doSwappiness);
    echo "Swappiness = $swp"
    
    # -------------------------------------------------------------------
    # Memory (summary) 
    # -------------------------------------------------------------------
    local msu=$(doMemSummary);
    echo "Memory (summary) = $msu" 
        
    # -------------------------------------------------------------------
    # Resolution
    # -------------------------------------------------------------------
    local rsl=$(doResolution);
    echo "Resolution = $rsl"
    
    # -------------------------------------------------------------------
    # Thermal 
    # -------------------------------------------------------------------
    local thm=$(doTemperature);
    echo "Thermal = $thm"
    
    # -------------------------------------------------------------------
    # Time 
    # -------------------------------------------------------------------
    local tdt=$(date +"%d-%m-%Y, %R");
    echo "Time = $tdt"
    
    # -------------------------------------------------------------------
    # Uptime 
    # -------------------------------------------------------------------
    local upt=$(doUptime);
    echo "Uptime = $upt"
    
    # -------------------------------------------------------------------
    # WiFi Interface 
    # -------------------------------------------------------------------
    local wif=$(doNetWifiIF);
    echo "WiFi Interface = $wif"
    
    # -------------------------------------------------------------------
    # WiFi SSID 
    # -------------------------------------------------------------------
    local wss=$(doNetWifiSSID);
    echo "WiFi SSID = $wss"
    
    # -------------------------------------------------------------------
    # WiFi Status 
    # -------------------------------------------------------------------
    local wst=$(doNetWifiStatus);
    echo "WiFi Status = $wst"
    
    # -------------------------------------------------------------------
    # WiFi Performance
    # -------------------------------------------------------------------
    local wfp=$(doNetWifiPerf);
    echo "WiFi Performance = $wfp"
    
    # -------------------------------------------------------------------
    # WiFi Inet 
    # -------------------------------------------------------------------
    local ip4=$(doNetIPv4);
    echo "IP v4 = $ip4" 
    
    # -------------------------------------------------------------------
    # WiFi Inet6 
    # -------------------------------------------------------------------
    local ip6=$(doNetIPv6);
    echo "IP v6 = $ip6" 
    
    # -------------------------------------------------------------------
    # Wired Interface
    # -------------------------------------------------------------------
    local eif=$(doNetWiredIF);
    echo "Wired Interface = $eif"
    
    # -------------------------------------------------------------------
    # Wired Status
    # -------------------------------------------------------------------
    local est=$(doNetWiredStatus);
    echo "Wired Status = $est"
    
    # -------------------------------------------------------------------
    # CPU description
    # -------------------------------------------------------------------
    local cpd=$(doCPU);
    echo "CPU description = $cpd"

    # -------------------------------------------------------------------
    # CPU usage in percents 
    # -------------------------------------------------------------------
    local cpu=$(doCPUUsage);
    echo "CPU usage in percents = $cpu"
    
    # -------------------------------------------------------------------
    # mem summary
    # -------------------------------------------------------------------
    local mus=$(doMemSummary);
    echo "mem summary = $mus"
    
    # -------------------------------------------------------------------
    # /home disk usage 
    # -------------------------------------------------------------------
    local hdk=$(doDriveUU "$HOME");
    echo "/home usage = $hdk"
    
    # -------------------------------------------------------------------
    # / disk usage 
    # -------------------------------------------------------------------
    local rdk=$(doDriveUU "/ ");
    echo "/ usage = $rdk"
}

function main() {
    local cmd=${1:-Menu}
    case "$cmd" in
        Cli)
            doCli
            ;;
        *)
            doMenu
    esac
}

main $1

