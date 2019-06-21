#!/usr/bin/env bash

# sysInfo

# call from .config/openbox/menu.xml like
#        <menu id="sysInfo" label="sysInfo" execute="sysInfo menu" />

# or from cli: sysInfo

# required awk, bc, inxi

COMMON_FUNCTIONS="$HOME/.config/openbox/scripts/pipe-common.sh"

if [ -f "$COMMON_FUNCTIONS" ]; then
    . "${COMMON_FUNCTIONS}" 2> /dev/null
else
    echo $"Error: Failed to locate $COMMON_FUNCTIONS" >&2
    exit 1
fi

# -------------------------------------------------------------------
# Audio Card
# -------------------------------------------------------------------
function doAudioCard() {
    local t=""
    t=$(inxi -A -c0 | grep evice | sed 's,Device..,,' | sed 's,: ,!,' | sed 's,.*!,,' | sed 's,driver:,!,' | sed 's,!.*,,')
    t=$(echo "$t" | sed 's,: ,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Audio Card Driver
# -------------------------------------------------------------------
function doAudioCardDriver() {
    local t=""
    t=$(inxi -A -c0 | grep 'driver' | sed 's/driver:/!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//")
    t=$(echo "$t" | sed 's,: ,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Audio Vol
# -------------------------------------------------------------------
function doAudioVol() {
    if amixer get Master | grep -q 'Right'
    then
        amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | tr -d '[]%'
    else
        awk -F"[][]" '/%/ { print $2 }' <(amixer sget Master)  | tr -d '[]%'
    fi
}

# -------------------------------------------------------------------
# Adapter 
# -------------------------------------------------------------------
function doAdapter() {
    acpi -a | grep "Adapter" | cut -f 2 -d':' | sed 's/\n//g' | sed "s/^[ \t]*//"
}

# -------------------------------------------------------------------
# Brightness 
# -------------------------------------------------------------------
function doBrightness(){
    local ab=""
    ab=$(cat /sys/class/backlight/intel_backlight/actual_brightness);
    local mb=""
    mb=$(cat /sys/class/backlight/intel_backlight/max_brightness);
    echo "$ab/$mb*100" | bc;
}

# -------------------------------------------------------------------
# Battery 
# -------------------------------------------------------------------
function doBatteryPerc() {
    upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage" | awk '/percentage/ {print $2}'
}

# -------------------------------------------------------------------
# CPU description
# -------------------------------------------------------------------
function doCPU() {
    grep 'model name' /proc/cpuinfo | cut -f 2 -d':' | uniq
}

# -------------------------------------------------------------------
# CPU usage in percents 
# -------------------------------------------------------------------
function doCPUUsage() {
    local tmp=""
    tmp=$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc)
    tmp=$(awkRound 0 "$tmp")
    echo "$tmp%"
}

# -------------------------------------------------------------------
# HDD info 
# -------------------------------------------------------------------
function doDriveHDD() {
    local t=""
    t=$(inxi -d -c0 | grep 'ID' | sed 's/(/!(/g' | sed 's,.*!,,' | sed 's/ID-1://g' | sed 's/(//g' | sed 's/)//g' | sed "s/^[ \t]*//" | awk '{print $1":",$3,$5,$6,$7,$8}')
    t=$(echo "$t" | sed 's/size: /!/g' | sed 's,!.*,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Optical info 
# -------------------------------------------------------------------
function doDriveOptical() {
    local t=""
    t=$(inxi -d -c0 | grep 'Optical' | sed 's/Optical:/Optical:!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | awk '{print $2":",$4,$6,$7,$8}')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Filesystem usage in percents and free space
# -------------------------------------------------------------------
function doDriveUU() {
    local d=${1}
    [ -z "$d" ] && d=$PWD
    local dv=""
    dv=$(df -h "$d" | awk 'NR==2 {print $1}')
    d=$(df -h "$d" | awk 'NR==2 {print $6}')
    local dus=""
    dus=$(inxi -pu -c0 | grep "$dv" | sed 's/size:/!size:/g' | sed 's,.*!,,' | awk '{print $9,$7,$2,$4,$5}')
    local ui=""
    ui=$(grep "$d " /etc/fstab | grep "UUID" | sed 's/UUID=/UUID=!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | awk '{print $1}')
    echo "$ui $dus"
}

# -------------------------------------------------------------------
# Graphic Card
# -------------------------------------------------------------------
function doGraphicCard() {
    local t=""
    t=$(inxi -G -c0 | grep evice | sed 's,Device..,,' | sed 's,: ,!,' | sed 's,.*!,,' | sed 's,driver:,!,' | sed 's,!.*,,')
    t=$(echo "$t" | sed 's,: ,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Graphic Server
# -------------------------------------------------------------------
function doGraphicServer() {
    local t=""
    t=$(inxi -G -c0 | awk '/erver/ {print $0}' | sed 's,: ,!,' | sed 's,.*!,,' | sed 's,:.*,,')
    t=$(echo "$t" | sed 's,: ,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Graphic Renderer
# -------------------------------------------------------------------
function doGraphicRenderer() {
    local t=""
    t=$(inxi -G -c0 | awk '/ender/ {print $0}' | sed 's,renderer: ,,' | sed 's,: ,!,' | sed 's,.*!,,')
    t=$(echo "$t" | sed 's,: ,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Desktop Environment
# -------------------------------------------------------------------
function doDE() {
    local t=""
    t=$(inxi -S -c0 | awk '/esktop/ {print $0}' | sed 's,esktop: ,!,' | sed 's,.*!,,')
    t=$(echo "$t" | sed 's,: ,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Load 
# -------------------------------------------------------------------
function doLoad() {
    local tmp=""
    tmp=$(uptime | awk '{print $10}' | cut -d ',' -f 1-2 | sed 's/\,/\./g');
    tmp=$(echo "$tmp * 100" | bc)
    awkRound 0 "$tmp"
}
    
# -------------------------------------------------------------------
# Machine Info
# -------------------------------------------------------------------
function doMachine() {
    local t=""
    t=$(inxi -M -c0 | awk '/obo/ {print $0}' | sed 's,: ,!,' | sed 's,.*!,,' | sed 's,model: ,,' | sed 's,serial:.*,,')
    t=$(echo "$t" | sed 's,: ,,')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Wan IP (public IP) 
# -------------------------------------------------------------------
function doNetWANIP() {
    local res=""
    res=$(curl -s "ifconfig.me");
    if [ $? -ne 0 ]; then
        res="";
    fi;
    res=$(echo "$res" | grep -Eo '[0-9\.]+');
    echo -e "$res"
}

# -------------------------------------------------------------------
# Network adapter 1 info
# -------------------------------------------------------------------
function doNetCard1() {
    inxi -i -c0 | grep 'Device-1' | sed 's/Device-1:/!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | sed 's/driver:/\/ driver:/g'
}

# -------------------------------------------------------------------
# Network adapter 2 info
# -------------------------------------------------------------------
function doNetCard2() {
    inxi -i -c0 | grep 'Device-2' | sed 's/Device-2:/!/g' | sed 's,.*!,,' | sed "s/^[ \t]*//" | sed 's/driver:/\/ driver:/g'
}

# -------------------------------------------------------------------
# Wifi Interface name
# -------------------------------------------------------------------
function doNetWifiIF() {
    nmcli device status | awk '/wifi/ {print $1}'
}

# -------------------------------------------------------------------
# WiFi SSID 
# -------------------------------------------------------------------
function doNetWifiSSID() {
    nmcli device status | awk '/wifi/ {print $4}'
}

# -------------------------------------------------------------------
# WiFi Status 
# -------------------------------------------------------------------
function doNetWifiStatus() {
    nmcli device status | awk '/wifi/ {print $3}'
}

# -------------------------------------------------------------------
# WiFi Performance
# -------------------------------------------------------------------
function doNetWifiPerf() {
    local tmp=""
    tmp=$(nmcli device status | awk '/wifi/ {print $4}')
    nmcli dev wifi | grep $tmp | grep "Mbit/s" | tr -s '[:blank:]''' | cut -d ' ' -f 3-9 | awk '{print $1,$2,$3 " Mb",$5"%",$7}'
}

# -------------------------------------------------------------------
# Wired Interface name
# -------------------------------------------------------------------
function doNetWiredIF() {
    nmcli device status | awk '/ethernet/ {print $1}'
}

# -------------------------------------------------------------------
# Wired Status 
# -------------------------------------------------------------------
function doNetWiredStatus() {
    nmcli device status | awk '/ethernet/ {print $3}'
}

# -------------------------------------------------------------------
# Local IPv4 
# -------------------------------------------------------------------
function doNetIPv4() {
    ifconfig -a | grep "inet " | grep -v 127 | cut -d ' ' -f 1-14 | awk '{print $3}'
}

# -------------------------------------------------------------------
# Local IPv6 
# -------------------------------------------------------------------
function doNetIPv6() {
    ifconfig -a | grep "inet6" | grep -v "::1" | cut -d ' ' -f 1-14 | awk '{print $3}'
}

# -------------------------------------------------------------------
# Process Summary
# -------------------------------------------------------------------
function doProc() {
    inxi -I -c0 | awk '/Processes/ {print $2}'
}

# -------------------------------------------------------------------
# Memory (available) 
# -------------------------------------------------------------------
function doMemAvail() {
    free -m | sed -n '2,2p' | tr -s '[:blank:]''' | cut -f 7 -d' '
}

# -------------------------------------------------------------------
# Memory (free)
# -------------------------------------------------------------------
function doMemFree() {
    free -m | awk 'NR==2{print ($2-$4)"M"}'
}

# -------------------------------------------------------------------
# Memory (total)
# -------------------------------------------------------------------
function doMemTotal() {
    free -m | awk 'NR==2{print $2"M"}'
}

# -------------------------------------------------------------------
# Memory (swap)
# -------------------------------------------------------------------
function doFreeSwap() {
    free -m | sed -n '3,3p' | tr -s '[:blank:]''' | cut -f 4 -d' '
}

# -------------------------------------------------------------------
# Memory (summary)
# -------------------------------------------------------------------
function doMemSummary() {
    local mem=""
    local memslash=""
    read -r memslash mem <<< $(free -m | awk 'NR==2{printf "%s/%sM %.0f%%", ($2-$4),$2,($2-$4)*100/$2 }')
    mem="${mem//%}"
    echo "$mem"
}

# -------------------------------------------------------------------
# Uptime 
# -------------------------------------------------------------------
function doUptime() {
    uptime -p | sed 's/days/d/g' | sed 's/day/d/g' | sed 's/hours/h/g' |  sed 's/hour/h/g' |  sed 's/minutes/m/g' |  sed 's/minute/m/g' |  sed 's/up //g'
}

# -------------------------------------------------------------------
# Service Manager
# -------------------------------------------------------------------
function doServerMan() {
    awk '{print $1}' < /proc/1/comm
}

# -------------------------------------------------------------------
# Resolution
# -------------------------------------------------------------------
function doResolution() {
    inxi -G -c0 | awk '/esolution/ {print $9}'
}

# -------------------------------------------------------------------
# Thermal 
# -------------------------------------------------------------------
function doTemperature() {
    local tmp=""
    tmp=$(acpi -t | grep 'Thermal' | awk 'NR==1 {print $4}')
    tmp=$(awkRound 0 "$tmp")
    echo "$tmp C" | awk '{print $1""$2}'
}

# -------------------------------------------------------------------
# Swappiness 
# -------------------------------------------------------------------
function doSwappiness() {
    #cat /proc/sys/vm/swappiness | sed "s/^[ \t]*//"
    sed "s/^[ \t]*//" /proc/sys/vm/swappiness 
}

# -------------------------------------------------------------------
# Weather 
# -------------------------------------------------------------------
function doWeather() {
    local t=""
    t=$(inxi -xxx -w -c0 | grep 'emperat' | awk 'NR==1 {print $2,$3,$4,$5,$7,$8}')
    echo "${t#"${t%%[![:space:]]*}"}"
}

# -------------------------------------------------------------------
# Distro 
# -------------------------------------------------------------------
function doDistro() {
    grep 'DISTRIB_DESCRIPTION' /etc/*-release  2> /dev/null | sed 's,=,!,' | sed 's,.*!,,' | sed -e "s/\"//g" | sed "s/$/ /g"
}

# -------------------------------------------------------------------
# Host 
# -------------------------------------------------------------------
function doHost() {
    uname -n
}

# -------------------------------------------------------------------
# OS 
# -------------------------------------------------------------------
function doOS() {
    uname -o
}

# -------------------------------------------------------------------
# Architecture 
# -------------------------------------------------------------------
function doArch() {
    uname -m | sed 's/_/-/g'
}

# -------------------------------------------------------------------
# Kernel 
# -------------------------------------------------------------------
function doKernel() {
    uname -r
}

# -------------------------------------------------------------------
# Create Openbox Pipe Menu
# -------------------------------------------------------------------
function doMenu() {
    menuBegin
    menuSep 
    menuItem "Audio Card: $(doAudioCard)";
    menuItem "Audio Card Driver: $(doAudioCardDriver)";
    menuItem "Volume: $$(doAudioVol)";
    menuItem "Distro: $(doDistro)";
    menuItem "Host: $(doHost)";
    menuItem "OS: $(doOS)";
    menuItem "Architecture: $(doArch)";
    menuItem "Kernel: $(doKernel)";
    menuItem "Service Manager: $(doServerMan)";
    menuItem "Adapter: $(doAdapter)";
    menuItem "Battery: $(doBatteryPerc)";
    menuItem "Brightness: $(doBrightness)";
    menuItem "Load: $(doLoad)";
    menuItem "Memory: Available $(doMemAvail)";
    menuItem "Free Swap: $(doFreeSwap)";
    menuItem "Swappiness: $(doSwappiness)";
    menuItem "Memory (summary): $(doMemSummary)";
    menuItem "Graphic Card: $(doGraphicCard)";
    menuItem "Graphic Server: $(doGraphicServer)";
    menuItem "Graphic Renderer: $(doGraphicRenderer)";
    menuItem "Resolution: $(doResolution)";
    menuItem "Desktop Environment: $(doDE)";
    menuItem "Temperature: $(doTemperature)";
    menuItem "Time: $(date +"%d-%m-%Y, %R")";
    menuItem "Uptime: $(doUptime)";
    menuItem "WiFi Interface: $(doNetWifiIF)";
    menuItem "WiFi SSID: $(doNetWifiSSID)";
    menuItem "WiFi Status: $(doNetWifiStatus)";
    menuItem "WiFi Performance: $(doNetWifiPerf)";
    menuItem "Local IPv4: $(doNetIPv4)";
    menuItem "Local IPv6: $(doNetIPv6)";
    menuItem "Wired Interface: $(doNetWiredIF)";
    menuItem "Wired Status: $(doNetWiredStatus)";
    menuItem "CPU description: $(doCPU)";
    menuItem "CPU usage: $(doCPUUsage)";
    menuItem "Memory summary: $(doMemSummary)";
    menuItem "HDD: $(doDriveHDD)";
    menuItem "Optical: $(doDriveOptical)";
    #menuItem "($HOME) $(doDriveUU "$HOME")" 
    #menuItem "(/) $(doDriveUU "/")" 
    menuItem "Machine Info: $(doMachine)"
    #menuItem "Processes: $(doProc)";
    #menuItem "Weather: $(doWeather)"
    menuEnd
}

# -------------------------------------------------------------------
# Command line interface
# -------------------------------------------------------------------
function doCli() {
    echo "Audio Card = $(doAudioCard)";
    echo "Audio Card Driver = $(doAudioCardDriver)";
    echo "Audio Vol = $(doAudioVol)";
    echo "Distro = $(doDistro)";
    echo "Host = $(doHost)";
    echo "OS = $(doOS)";
    echo "Architecture = $(doArch)";
    echo "Kernel = $(doKernel)";
    echo "Service Manager = $(doServerMan)";
    echo "Adapter = $(doAdapter)";
    echo "Battery = $(doBatteryPerc)";
    echo "Brightness = $(doBrightness)";
    echo "Load = $(doLoad)";
    echo "Memory = $(doMemAvail)";
    echo "Swap = $(doFreeSwap)";
    echo "Swappiness = $(doSwappiness)";
    echo "Memory (summary) = $(doMemSummary)";    
    echo "Graphic Card = $(doGraphicCard)";
    echo "Graphic Server = $(doGraphicServer)";
    echo "Graphic Renderer = $(doGraphicRenderer)";
    echo "Resolution = $(doResolution)";
    echo "DE = $(doDE)";
    echo "Thermal = $(doTemperature)";
    echo "Time = $(date +"%d-%m-%Y, %R")";
    echo "Uptime = $(doUptime)";
    echo "Wan IP = $(doNetWANIP)";
    echo "Network Card1 = $(doNetCard1)";
    echo "Network Card2 = $(doNetCard2)";
    echo "WiFi Interface = $(doNetWifiIF)";
    echo "WiFi SSID = $(doNetWifiSSID)";
    echo "WiFi Status = $(doNetWifiStatus)";
    echo "WiFi Performance = $(doNetWifiPerf)";
    echo "IP v4 = $(doNetIPv4)" 
    echo "IP v6 = $(doNetIPv6)" 
    echo "Wired Interface = $(doNetWiredIF)"
    echo "Wired Status = $(doNetWiredStatus)"
    echo "CPU description = $(doCPU)"
    echo "CPU usage in percents = $(doCPUUsage)"
    echo "HDD = $(doDriveHDD)"
    echo "Optical = $(doDriveOptical)"
    echo "($HOME) = $(doDriveUU "$HOME")"
    echo "(/) = $(doDriveUU "/")"
    echo "Machine Info = $(doMachine)"
    echo "Processes = $(doProc)"
    echo "Weather = $(doWeather)"
}

function main() {
    local cmd=${1:-menu}
    case "$cmd" in
        cli)
            doCli
            ;;
        *)
            doMenu
    esac
}

main "$1"

