#!/usr/bin/env bash
#===========================================
# Distingue quando se esta em um sistema chrooted
#===========================================
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#===========================================
# Não armazenar as linhas duplicadas ou linhas que começam com espaço no historico
#===========================================
export HISTCONTROL="erasedups:ignoreboth"

#===========================================
# Define do tamanho e formato do historico.
#===========================================
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTTIMEFORMAT="%h %d %H:%M:%S "
#don't record commands preceeded by a space
export HISTIGNORE="&:[ ]*:clear:exit"

#===========================================
# Define PROMPT_COMMAND do lado esquerdo inicial
# Unifica o history através das sessões bash
#===========================================
export PROMPT_COMMAND="history -a; history -r"

#===========================================
# Adicionar ao Historico e não substitui-lo
#===========================================
shopt -s histappend

#===========================================
# These  two options are useful for debugging.
#===========================================
#set -o nounset     # These  two options are useful for debugging.
#set -o xtrace

#===========================================
#
#===========================================
set -o notify
set -o noclobber
set -o ignoreeof

#===========================================
# Enable options:
#===========================================
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify

#===========================================
# Necessary for programmable completion.
#===========================================
shopt -s extglob

#===========================================
# Variaveis de Cores (uso geral)
#===========================================
if tput setaf 1 &> /dev/null; then
    tput sgr0; # reset colors
    export _cl_bold=$(tput bold);
    export _cl_underline=$(tput sgr 0 1);
    export _cl_tan=$(tput setaf 3);
    export _cl_reset=$(tput sgr0);
    export _cl_black=$(tput setaf 0);
    export _cl_blue=$(tput setaf 33);
    export _cl_cyan=$(tput setaf 37);
    export _cl_green=$(tput setaf 64);
    export _cl_orange=$(tput setaf 166);
    export _cl_purple=$(tput setaf 125);
    export _cl_red=$(tput setaf 124);
    export _cl_violet=$(tput setaf 61);
    export _cl_white=$(tput setaf 15);
    export _cl_yellow=$(tput setaf 136);
else
    export _cl_bold='';
    export _cl_underline=''
    export _cl_tan='';
    export _cl_reset="\e[0m";
    export _cl_black="\e[1;30m";
    export _cl_blue="\e[1;34m";
    export _cl_cyan="\e[1;36m";
    export _cl_green="\e[1;32m";
    export _cl_orange="\e[1;33m";
    export _cl_purple="\e[1;35m";
    export _cl_red="\e[1;31m";
    export _cl_violet="\e[1;35m";
    export _cl_white="\e[1;37m";
    export _cl_yellow="\e[1;33m";
fi

#===========================================
# Variaveis de Cores (especialmente para o prompt)
#===========================================
export NONE="\[\033[0m\]" # Eliminar as Cores, deixar padrão)

## Cores de Fonte
export K="\[\033[0;30m\]" # Black (Preto)
export R="\[\033[0;31m\]" # Red (Vermelho)
export G="\[\033[0;32m\]" # Green (Verde)
export Y="\[\033[0;33m\]" # Yellow (Amarelo)
export B="\[\033[0;34m\]" # Blue (Azul)
export M="\[\033[0;35m\]" # Magenta (Vermelho Claro)
export C="\[\033[0;36m\]" # Cyan (Ciano - Azul Claro)
export W="\[\033[0;37m\]" # White (Branco)

## Efeito Negrito (bold) e cores
export BK="\[\033[1;30m\]" # Bold+Black (Negrito+Preto)
export BR="\[\033[1;31m\]" # Bold+Red (Negrito+Vermelho)
export BG="\[\033[1;32m\]" # Bold+Green (Negrito+Verde)
export BY="\[\033[1;33m\]" # Bold+Yellow (Negrito+Amarelo)
export BB="\[\033[1;34m\]" # Bold+Blue (Negrito+Azul)
export BM="\[\033[1;35m\]" # Bold+Magenta (Negrito+Vermelho Claro)
export BC="\[\033[1;36m\]" # Bold+Cyan (Negrito+Ciano - Azul Claro)
export BW="\[\033[1;37m\]" # Bold+White (Negrito+Branco)

## Cores de fundo (backgroud)
export BGK="\[\033[40m\]" # Black (Preto)
export BGR="\[\033[41m\]" # Red (Vermelho)
export BGG="\[\033[42m\]" # Green (Verde)
export BGY="\[\033[43m\]" # Yellow (Amarelo)
export BGB="\[\033[44m\]" # Blue (Azul)
export BGM="\[\033[45m\]" # Magenta (Vermelho Claro)
export BGC="\[\033[46m\]" # Cyan (Ciano - Azul Claro)
export BGW="\[\033[47m\]" # White (Branco)

#=============================================
# TERMCAP Setup
#=============================================
# enter blinking mode - red
export LESS_TERMCAP_mb=$(printf '\e[01;31m')
# enter double-bright mode - bold, magenta
export LESS_TERMCAP_md=$(printf '\e[01;35m')
# turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_me=$(printf '\e[0m')
# leave standout mode
export LESS_TERMCAP_se=$(printf '\e[0m')
# enter standout mode - green
export LESS_TERMCAP_so=$(printf '\e[01;32m')
# leave underline mode
export LESS_TERMCAP_ue=$(printf '\e[0m')
# enter underline mode - blue
export LESS_TERMCAP_us=$(printf '\e[04;34m')
