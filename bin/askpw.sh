#!/bin/bash
#zenity --forms --modal --text=" Autenticação Necessária " --title="Entre com a senha"  --add-password="Senha: "
# Solicita senha sudo e valida a entrada
function do_ask_pw() {
    local has_yad=`which yad`
    local Psw=""
    local p=0
    for p in $(seq 1 3 ); do
        sudo -K
        if [ -z "$has_yad" ]; then
            Psw=`zenity --forms --modal --text="Autenticação Necessária $p / 3" --title="Entre com a senha"  --add-password="Senha:"`
        else
            Psw=`yad --entry --entry-text="xxxx" --hide-text --text="Autenticação Necessária $p / 3" --title="Entre com a senha"  --center --on-top --width=260`
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
    Psw=""
    echo "$Psw"
    exit 1
}
do_ask_pw