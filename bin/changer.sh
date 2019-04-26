#!/usr/bin/env bash

if [ -f "$HOME/bin/mylog" ]; then
    . "$HOME/bin/mylog"
fi

function is_running_X(){
    if ! xset q &>/dev/null; then
        return 1
    fi
    return 0
}

function change_wallpaper(){
	local old_IFS=$IFS
	IFS="
	"
	local WallDir="$HOME/Imagens/Wallpaper"
	local WallList=( `find "$WallDir" -type f -iregex ".*/.*[.]\(jpe?g\|png\|gif\|bmp\)"` )
	IFS=$old_IFS
	local MaxFiles=${#WallList[@]}
	#let "number = $RANDOM"
	#let CurrIndex="`cat $WallDir/.last` + $number"
	local LastFile="$WallDir/.last"
	if [ -f "$LastFile" ]; then 
	    let CurrIndex="`cat "$LastFile"` + 1"
	    if [ $CurrIndex -ge $MaxFiles ]; then
	        let CurrIndex=1
	    fi
	else
	    let CurrIndex=1
	fi
	local number
	let number=$CurrIndex
	echo $number > "$WallDir"/.last
	nitrogen --set-scaled --save "${WallList[$number]}"
	log "Wallpaper changed to: ${WallList[$number]}"
}

function kill_older(){
    local s_name="${0##*/}"
    local my_pid=$$
    local v_pids=( $(ps -aux | grep "$s_name" | egrep -v 'grep --color=auto' | sort -u | awk '{print $1"_"$2"_"$9"_"$12}') )
    local v_len=${#v_pids[@]}
    let v_len=v_len-1
    local i="0"
    local one_pid="0"
    local p_name=""
    local aux=""
    for i in $(seq 0 $v_len ); do 
        aux=$(echo "${v_pids[$i]}" | sed -e "s/_/ /g");
        one_pid=$(echo "$aux" | awk '{print $2}');
        aux=$(echo "$aux" | awk '{print $4}')
        p_name="${aux##*/}"
        #log "$i ----  ${v_pid[$i]}   pid=$one_pid  name=$p_name"
        if [ "$one_pid" != "$my_pid" ] && [ "$p_name" == "$s_name" ]; then
            log "Older instances found: pid=$one_pid  name=$p_name "
            kill "$one_pid" &>/dev/null
        fi
    done
    return 0
}

function snore()
{
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read ${1:+-t "$1"} -u $_snore_fd || :
}

function main(){
	log "==[ Changer started ]=="
    if ! is_running_X ; then
        log "No X server at \$DISPLAY [$DISPLAY]" >&2
        exit 0
    fi
    kill_older
    nitrogen --restore
    snore 0.2
	while is_running_X ; do 
	    if [ -z "$DISPLAY" ]; then
    	    DISPLAY=:0.0
    	fi
		snore 420;
		change_wallpaper;
	done;	
}

main
