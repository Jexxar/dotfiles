#!/bin/bash
#for i in /proc/[0-9]*/fd/*
#do
#    var="$(readlink $i)"
#    if test x"$var" != x"${var#/dev/snd/pcm}"
#    then
#        echo $i
#    fi
#done
# For example ('ardour2' 'gmpc').
delay_progs=('vlc' 'xplayer' 'bino' 'curlew' 'avidemux' 'mpv' 'smplayer' 'smtube' 'gmpc' 'ardour2' 'xine' 'totem' 'parole' 'qmmp' 'kaffeine' 'kmplayer' 'kdenlive' 'ffmpeg' )

# Names of programs which, when using sound server, you wish to delay the screensaver.
stream_progs=('vlc' 'smplayer' 'smtube' 'chrome' 'firefox' 'opera' 'vivaldi' 'brave' 'chromium' 'epiphany' 'youtube-dl' 'midori' 'min' 'falkon')

function isUsingSnd() {
    local str=$(pacmd list-sink-inputs | grep "application.process.id" | awk '{print $3}' | sed 's/\"//g' | sed 's/\n//g')
    [ -z $str ] && return 1
    local arr=( $str )
    local nm_ps=""
    for i in "${arr[@]}"; do 
        nm_ps=$(ps -p $i -o comm=;)
        for prog in "${delay_progs[@]}"; do
            if [ "$prog" = "$nm_ps" ] ; then
                echo "checkDelayProgs(): Delaying the screensaver because a program on the delay list, \"$prog\", is running..."
                return 0
            fi
        done
    done
    for i in "${arr[@]}"; do 
        nm_ps=$(ps -p $i -o comm=;)
        for prog in "${stream_progs[@]}"; do
            if [ "$prog" = "$nm_ps" ] ; then
                echo "checkDelayProgs(): Delaying the screensaver because a program on the delay list, \"$prog\", is running..."
                return 0
            fi
        done
    done
    return 1
}

function isStreamUsingSnd() {
    local str=$(pacmd list-sink-inputs | grep "application.process.id" | awk '{print $3}' | sed 's/\"//g' | sed 's/\n//g')
    [ -z $str ] && return 1
    local arr=( $str )
    local nm_ps=""
    for i in "${arr[@]}"; do 
        nm_ps=$(ps -p $i -o comm=;)
        for prog in "${stream_progs[@]}"; do
            if [ "$prog" = "$nm_ps" ] ; then
                echo "checkDelayProgs(): Delaying the screensaver because a program on the delay list, \"$prog\", is running..."
                return 0
            fi
        done
    done
    return 1
}

function streamUsingSndName() {
    local nm_ps=""
    local str=$(pacmd list-sink-inputs | grep "application.process.id" | awk '{print $3}' | sed 's/\"//g' | sed 's/\n//g')
    if [ -z $str ]; then 
        echo "$nm_ps" 
        return 0
    fi
    local arr=( $str )
    for i in "${arr[@]}"; do 
        nm_ps=$(ps -p $i -o comm=;)
        for prog in "${stream_progs[@]}"; do
            if [ "$prog" = "$nm_ps" ] ; then
                echo "$nm_ps"
                return 0
            fi
        done
    done
    echo "$nm_ps"
    return 0
}

streamUsingSndName