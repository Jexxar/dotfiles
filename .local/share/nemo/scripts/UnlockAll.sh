#!/bin/bash

if [[ $# -eq 0 ]]; then 
    exit 1
fi    

function do_ask_pw() {
    local has_yad=`which yad`
    local Psw=""
    local p
    for p in $(seq 1 3 ); do
        sudo -K
        if [ -z "$has_yad" ]; then
            Psw=`zenity --forms --modal --text="Autenticação Necessária $p / 3" --title="Entre com a senha"  --add-password="Senha:"`
        else
            Psw=`yad --entry --entry-text="" --hide-text --text="Autenticação Necessária $p / 3" --title="Entre com a senha"  --center --on-top --width=260`
        fi
        if [[ ${?} -ne 0 || -z ${Psw} ]]; then
            Psw=""
            echo "$Psw"
            return 1
        fi;
        sudo -vSp '' <<<${Psw}
        if [[ ${?} -eq 0 ]]; then
            echo "$Psw"
            return 0
        fi;
    done
    notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/error.png "Senha Inválida após 3 tentativas"
    return 1
}

# Set IFS so that it won't consider spaces as entry separators.  
# Without this, spaces in file/folder names can make the loop go wacky.
IFS=$'\n'

if [ -z $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
    NAUTILUS_SCRIPT_SELECTED_FILE_PATHS=$*
fi

if [[ $UID -ne 0 ]]; then 
    mPsw=`do_ask_pw`
    if [[ ${?} -ne 0 || -z ${mPsw} ]]; then
        exit 1
    fi
fi

meuusr="${USER}"

# Loop through the list (from either Nautilus or the command line)
for ARCHIVE_FULLPATH in $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS; do
    NEWDIRNAME=${ARCHIVE_FULLPATH%.*}
    FILENAME=${ARCHIVE_FULLPATH##*/}
    NAME=${ARCHIVE_FULLPATH##*/.*}
    
    if [[ $UID -ne 0 ]]; then 
        echo "$mPsw" | sudo -S chown -R $meuusr:$meuusr "$ARCHIVE_FULLPATH"
    else
        chown -R $meuusr:$meuusr "$ARCHIVE_FULLPATH"
    fi

    if [[ $? != 0 ]]; then 
        notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/error.png "Erro chown $? em $ARCHIVE_FULLPATH";
        unset mPsw
        unset meuusr
        exit 1
    fi    

    if [[ $UID -ne 0 ]]; then 
        sudo -K
        echo "$mPsw" | sudo -S chmod -R 777 "$ARCHIVE_FULLPATH"
    else
        chmod -R 777 "$ARCHIVE_FULLPATH"
    fi

    unset mPsw
    unset meuusr
    
    if [[ $? != 0 ]]; then 
        notify-send -t 5000 -i /usr/share/icons/gnome/32x32/status/error.png "Erro chmod $? em $ARCHIVE_FULLPATH";
        exit 1
    fi    
done
