#!/usr/bin/env bash

#==============================================
# History options
#==============================================
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=”ls:exit:pwd:clear:cls”
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend

#==============================================
# Source goto.sh to handle directories
#==============================================
[[ -s "$HOME/bin/goto.sh" ]] && source ~/bin/goto.sh

#==============================================
# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#==============================================
#export SHORT_HOSTNAME=$(hostname -s)

#==============================================
# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#==============================================
#export SHORT_USER=${USER:0:8}

#==============================================
# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#==============================================
#export SHORT_TERM_LINE=true

#==============================================
# Set Xcursor environment
#==============================================
export XCURSOR_PATH="/usr/share/icons:~/.local/share/icons:$XCURSOR_PATH"

#==============================================
# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#==============================================
export VCPROMPT_EXECUTABLE=~/bin/vcprompt

#==============================================
# Set this to false to turn off version control status checking within the prompt for all themes
#==============================================
export SCM_CHECK=true

#==============================================
# Path to the bash it configuration
#==============================================
export BASH_IT="$HOME/.bash_it"

#==============================================
# Lock and Load a custom theme file under /.bash_it/themes/
#==============================================
if [ "$TERM" = "linux" ]; then
    export BASH_IT_THEME='pure'
else
    #export BASH_IT_THEME='powerline-multiline-custom'
    export BASH_IT_THEME='demula'
fi

#==============================================
# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
#==============================================
# export BASH_IT_REMOTE='bash-it'

#==============================================
# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
#==============================================
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

#==============================================
# Create another plugin to auto export functions for the session
#==============================================
function exports_gen() {
    local cstfile="$BASH_IT/plugins/available/custom.plugin.bash"
    local expfile="$BASH_IT/plugins/available/exports.plugin.bash"
    [ -f "$expfile" ] && rm -f "$expfile"
    echo -e "#!/usr/bin/env bash\n" > "$expfile"
    echo -e "#==============================================" >> "$expfile"
    echo -e "# Exports (auto generated. Do not edit)" >> "$expfile"
    echo -e "#==============================================\n" >> "$expfile"
    echo -e "function do_exports() {" >> "$expfile"
    grep "^function" "$cstfile" | cut -d'(' -f1 | sed -e 's/function //g' | grep -v "^_\|exports_gen\|usage\|prompt\|do_exports" | sort | awk '{print "    export -f",$1}' >> "$expfile"
    echo -e "}\n" >> "$expfile"
    echo -e "do_exports" >> "$expfile"
    return 0
}

#==============================================
# Generate an export regen for my custom functions
#==============================================
exports_gen

#==============================================
# Load Bash It
#==============================================
source "$BASH_IT"/bash_it.sh

#==============================================
# greetings if we can do it
#==============================================
if [ "$TERM" != "linux" ]; then
    greetings
fi
