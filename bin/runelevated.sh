#!/usr/bin/env bash
# Pede senha e faz autenticacao
function ask_pw() {
    local Psw=""
    local p
    for p in $(seq 1 3 ); do
        sudo -K
        Psw=$(zenity --forms --modal --text="Autenticação Necessária $p / 3" --title="Entre com a senha"  --add-password="Senha: ")
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
}

# Executa o comando com sudo
function run_psudo() {
    if [ $# -eq 0 ]; then
        return 0
    fi
    local mPsw=`ask_pw`
    if [[ ${?} -ne 0 || -z ${mPsw} ]]; then
        return 0
    fi
    sudo -Sp '' "$1" <<<${mPsw}
    unset mPsw
    return 0
}

run_psudo "$@"

