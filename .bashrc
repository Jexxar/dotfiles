#!/usr/bin/env bash

# Source goto 
[[ -s "/usr/local/share/goto.sh" ]] && source /usr/local/share/goto.sh

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set Xcursor environment
export XCURSOR_PATH="/usr/share/icons:~/.local/share/icons:$XCURSOR_PATH"

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
export VCPROMPT_EXECUTABLE=~/bin/vcprompt

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Path to the bash it configuration
export BASH_IT="/home/usuario/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
if [ "$TERM" = "linux" ]; then
    export BASH_IT_THEME='pure'
else
    export BASH_IT_THEME='powerline-multiline-custom'
fi

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

#==============================================
# gera export regen de funcoes customizadas
#==============================================
function exports_gen() {
    if [ -f ~/.bash_it/plugins/available/exports.plugin.bash ]; then
        rm -f ~/.bash_it/plugins/available/exports.plugin.bash
    fi
    echo -e "#! /bin/bash" > ~/.bash_it/plugins/available/exports.plugin.bash
    echo -e "#==============================================" >> ~/.bash_it/plugins/available/exports.plugin.bash
    echo -e "# Exports (auto generated. Do not edit) - Bash Shell" >> ~/.bash_it/plugins/available/exports.plugin.bash
    echo -e "#==============================================" >> ~/.bash_it/plugins/available/exports.plugin.bash
    echo -e "function do_exports() {" >> ~/.bash_it/plugins/available/exports.plugin.bash
    cat ~/.bash_it/plugins/available/custom.plugin.bash | grep -v "^#" | grep -v exports_gen | grep -v "is a function" | grep -v " function)" | grep -v usage | grep -v do_exports | grep -v prompt | grep '^function' | tr -d '(' | tr -d ')' | awk '{print "export -f",$2}' >> ~/.bash_it/plugins/available/exports.plugin.bash ;
    echo -e "}\n" >> ~/.bash_it/plugins/available/exports.plugin.bash
    echo -e "do_exports" >> ~/.bash_it/plugins/available/exports.plugin.bash
}

#==============================================
# gera export de funcoes customizadas
#==============================================
exports_gen

# Load Bash It
source "$BASH_IT"/bash_it.sh

if [ "$TERM" != "linux" ]; then
    greetings
fi
