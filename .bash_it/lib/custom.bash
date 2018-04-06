#! /bin/bash
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

#=============================================
# Prompt do lado direito no estilo zsh inicial
#=============================================
#export RPROMPT="⎇ "
export RPROMPT=""

#===========================================
# Define qual sera o manpager most ou less
#===========================================
export MANPAGER="/usr/bin/most"

#===========================================
# Define qual sera o scrip usado pelo sudo no askpass
#===========================================
export SUDO_ASKPASS="${HOME}/bin/askpw.sh"

#===========================================
# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
#===========================================
export PYTHONIOENCODING='UTF-8';

#===========================================
# Prefer pt_BR and use UTF-8.
#===========================================
export LANG='pt_BR.UTF-8';
export LC_ALL='pt_BR.UTF-8';

#===========================================
# for cache function settings
#===========================================
export CACHE_DIR="/tmp"

#===========================================
# Some settings
#===========================================

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
# Don't want coredumps.
#===========================================
ulimit -S -c 0

#===========================================
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
    export bold=$(tput bold);
    export underline=$(tput sgr 0 1);
    export tan=$(tput setaf 3);
    export reset=$(tput sgr0);
    export black=$(tput setaf 0);
    export blue=$(tput setaf 33);
    export cyan=$(tput setaf 37);
    export green=$(tput setaf 64);
    export orange=$(tput setaf 166);
    export purple=$(tput setaf 125);
    export red=$(tput setaf 124);
    export violet=$(tput setaf 61);
    export white=$(tput setaf 15);
    export yellow=$(tput setaf 136);
else
    export bold='';
    export underline=''
    export tan='';
    export reset="\e[0m";
    export black="\e[1;30m";
    export blue="\e[1;34m";
    export cyan="\e[1;36m";
    export green="\e[1;32m";
    export orange="\e[1;33m";
    export purple="\e[1;35m";
    export red="\e[1;31m";
    export violet="\e[1;35m";
    export white="\e[1;37m";
    export yellow="\e[1;33m";
fi

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


#=============================================
# Outras variaveis de ambiente
#=============================================

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='jexxar@github.com'

# Don't check mail when opening terminal.
#unset MAILCHECK

# Change this to your console based IRC client of choice.
#export IRC_CLIENT='irssi'

# Default console editor
export EDITOR='nano'

# git author data comes from .gitconfig and is saved as environment variables
# that are sent to ssh connections to maintain you identity across machines
export GIT_AUTHOR_NAME=`git config user.name`
export GIT_AUTHOR_EMAIL=`git config user.email`
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

# Java stuff
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

#===========================================
# Reusa o ssh-agent e/ou gpg-agent entre os logins
# para determinadas chaves
#===========================================
if [ $UID -ne "0" ]; then
    /usr/bin/keychain --eval --quiet -Q $HOME/.ssh/githubkey_rsa ;
    [ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh;
    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg;
fi
