#!/usr/bin/env bash

#==============================================
# Remember:
#   Most of the settings are stored in: ~/.bash_it/lib/custom.bash
#   Check that file before include new settings here.
#==============================================
# 1) History options
# 2) Shell options 
# 3) Basic exports
# 4) Default colors 
#==============================================

#==============================================
# Source goto.sh to handle directories
#==============================================
[[ -s "${HOME}/bin/goto.sh" ]] && source ~/bin/goto.sh

#==============================================
# Set vcprompt executable path for scm advance info in prompt (bash_it demula theme)
# https://github.com/djl/vcprompt
#==============================================
export VCPROMPT_EXECUTABLE="${HOME}/bin/vcprompt"

#==============================================
# Set this to false to turn off version control status checking within the prompt for all bash_it themes
#==============================================
export SCM_CHECK=true

#==============================================
# Path to the bash it configuration
#==============================================
export BASH_IT="${HOME}/.bash_it"

#==============================================
# Lock and Load a custom theme file under /.bash_it/themes/
#==============================================
if [ "$TERM" = "linux" ]; then
    export BASH_IT_THEME='pure'
else
    export BASH_IT_THEME='powerline-multiline-custom'
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
# Create a dynamic plugin to auto export all my custom functions (plugins) for the session
#==============================================
function exports_gen() {
    local cstfile="$BASH_IT/plugins/available/custom.plugin.bash"
    local expfile="$BASH_IT/plugins/available/exports.plugin.bash"
    [ -f "$expfile" ] && rm -f "$expfile"
    echo -e "#\041/usr/bin/env bash\n" > "$expfile"
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
