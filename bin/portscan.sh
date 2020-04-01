#!/bin/bash
###########################################
#Coded by: CORSHINE                       #
#Github: https://github.com/xcorshinex    #
###########################################

function banner() {
    echo "======================================================================="
    echo "|                         CODED BY CORSHINE                           |"
    echo "|                       Instagram: @corshine_                         |"
    echo "|                       Use With Your Own Risk!                       |"
    echo "======================================================================="
    printf "\n"
}

function alarm {
    local timeout=$1; shift;
    bash -c "$@" &
    local pid=$!
    {
        sleep "$timeout"
        kill $pid 2> /dev/null
    } &
    wait $pid 2> /dev/null 
    return $?
}

function scan {
    if [[ -z $1 || -z $2 ]]; then
        echo "Usage: ./corshineportscan <host> <port, ports, or port-range>"
        echo "Example: ./corshineportscan facebook.com 22-80"
        return
    fi
    local host=$1
    local ports=()
    case $2 in
        *-*)
            IFS=- read start end <<< "$2"
            for ((port=start; port <= end; port++)); do
                ports+=($port)
            done
        ;;
        *,*)
            IFS=, read -ra ports <<< "$2"
        ;;
        *)
            ports+=($2)
        ;;
    esac
    for port in "${ports[@]}"; do
        alarm 1 "echo >/dev/tcp/$host/$port" && echo "$port/tcp open" || echo "$port/tcp closed"
    done
}

banner
scan "$@"
