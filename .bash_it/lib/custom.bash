#!/usr/bin/env bash
#==============================================
# Set vcprompt executable path for scm advance info in prompt (bash_it demula theme)
# https://github.com/djl/vcprompt
#==============================================
export VCPROMPT_EXECUTABLE="${HOME}/bin/vcprompt"

#===========================================
# Identifies debian chrooted
#===========================================
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#===========================================
# History file options
#===========================================
export HISTCONTROL="erasedups:ignoreboth"
export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTTIMEFORMAT="%h %d %H:%M:%S "
#don't record commands preceeded by a space
export HISTIGNORE="&:[ ]*:clear:exit:cls:ls:ll"

#===========================================
# Define PROMPT_COMMAND and Unifies history 
# filea thru bash sessions
#===========================================
export PROMPT_COMMAND="history -a; history -r"

#===========================================
# Enable options:
#===========================================
# These two options are useful for debugging.
#set -o nounset
#set -o xtrace

set -o notify
set -o ignoreeof

# Do not overwrite files when redirecting using ">".
# Note that you can still override this with ">|".
set -o noclobber

# When the command contains an invalid history operation (for instance when
# using an unescaped "!" (I get that a lot in quick e-mails and commit
# messages) or a failed substitution (e.g. "^foo^bar" when there was no "foo"
# in the previous command line), do not throw away the command line, but let me
# correct it.
shopt -s histreedit;

# append to the Bash history file, rather than overwriting it
shopt -s histappend

# review a command to make sure it's the one you expected and edit it
shopt -s histverify

# rezize the windows-size if needed
shopt -s checkwinsize

# check if the user isn't root
if [ "$UID" != 0 ]; then
  # case-insensitive globbing (used in pathname expansion)
  shopt -s nocaseglob
  # autocorrect typos in path names when using `cd`
  shopt -s cdspell
fi

# Do not autocomplete when accidentally pressing Tab on an empty line. (It takes
# forever and yields "Display all 15 gazillion possibilites?")
shopt -s no_empty_cmd_completion;

# Necessary for programmable completion.
shopt -s extglob

shopt -s cdable_vars
shopt -s autocd
shopt -s globstar
shopt -s checkhash
shopt -s sourcepath
shopt -s cmdhist


#===========================================
# Colors 
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
# Colors 
#===========================================
#export NONE="\[\033[0m\]" # Reset colors

## Foreground  
#export K="\[\033[0;30m\]" # Black 
#export R="\[\033[0;31m\]" # Red 
#export G="\[\033[0;32m\]" # Green 
#export Y="\[\033[0;33m\]" # Yellow 
#export B="\[\033[0;34m\]" # Blue 
#export M="\[\033[0;35m\]" # Magenta
#export C="\[\033[0;36m\]" # Cyan  
#export W="\[\033[0;37m\]" # White 
#export BK="\[\033[1;30m\]" # Bold+Black 
#export BR="\[\033[1;31m\]" # Bold+Red 
#export BG="\[\033[1;32m\]" # Bold+Green 
#export BY="\[\033[1;33m\]" # Bold+Yellow 
#export BB="\[\033[1;34m\]" # Bold+Blue 
#export BM="\[\033[1;35m\]" # Bold+Magenta
#export BC="\[\033[1;36m\]" # Bold+Cyan 
#export BW="\[\033[1;37m\]" # Bold+White 

## Background
#export BGK="\[\033[40m\]" # Black 
#export BGR="\[\033[41m\]" # Red 
#export BGG="\[\033[42m\]" # Green 
#export BGY="\[\033[43m\]" # Yellow
#export BGB="\[\033[44m\]" # Blue 
#export BGM="\[\033[45m\]" # Magenta
#export BGC="\[\033[46m\]" # Cyan 
#export BGW="\[\033[47m\]" # White

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

#===========================================
# Console based text editor
#===========================================
hash nano 2> /dev/null && export EDITOR="nano"
[ -z "$EDITOR" ] && { hash micro 2> /dev/null && export EDITOR="micro"; }
[ -z "$EDITOR" ] && { hash myedit 2> /dev/null && export EDITOR="myedit"; }

