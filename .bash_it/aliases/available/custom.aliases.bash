#
# -binaryanomaly
cite 'about-alias'
about-alias 'Custom aliases for this installation.'

#==============================================
# Aliases - Bash Shell
#==============================================
alias shrld='source ~/.bashrc'
alias bshrld='source ~/.bashrc'
alias cd..='cd ..'

# confirm before doing something
alias cp="cp -i"
alias rm='rm -i'

alias debug="set -o nounset; set -o xtrace"
# human-readable sizes
alias df='df -h'
alias dir='dir -lah1FX --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'

# systemd shortcuts
alias sdfail='sudo systemctl --no-pager --failed; sudo journalctl --no-pager -b -p4'
alias jo='journalctl --no-pager -b -g"fail|emerg|alert|crit|error|warn"'
alias dr='$EXEC_AS_USER systemctl daemon-reload; systemctl daemon-reload --user'

# disk utiliztion
alias ducks='du -cks * | sort -rn | head'

# custom ls
#alias lf='/bin/ls -lah1FX --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
#alias ll='/bin/ls -lahXF --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
#alias ls='/bin/ls -ahXF --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
alias lf='/bin/ls -lah1FX --group-directories-first --human-readable --time-style=long-iso --color=auto'
alias ll='/bin/ls -lahXF --group-directories-first --human-readable --time-style=long-iso --color=auto'
alias ls='/bin/ls -ahXF --group-directories-first --human-readable --time-style=long-iso --color=auto'

# date and time
alias nowtime='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# 
alias reswap='sudo swapoff -a && sudo swapon -a'
alias wgec='wget -c'

# shortcut for iptables and pass it via sudo
# and display all rules
alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'

# dumb tmux tricks
alias tsad="printf '\033k┐(T_T)┌\033\\'"
alias tshrug="printf '\033k┐(\`-\`)┌\033\\'"
alias tlol="printf '\033k┐(^0^)┌\033\\'"

# java helping aliases
if hash java &> /dev/null; then
    alias java.debug.enable='export JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,address=5009,suspend=y"'
    alias java.debug.disable='export JAVA_OPTS=""'
fi

alias ctags='ctags --exclude={docs,cache,tiny_mce,layout} --recurse';

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
    alias reboot='sudo /sbin/reboot'
    alias poweroff='sudo /sbin/poweroff'
    alias halt='sudo /sbin/halt'
    alias shutdown='sudo /sbin/shutdown'
fi

# colored grep
# Need to check an existing file for a pattern that will be found to ensure
# that the check works when on an OS that supports the color option
#if grep --color=auto "shell " "${BASH_IT}/"*.md &> /dev/null; then
#    alias grep='grep --color=auto'
#    alias egrep='egrep --color=auto'
#    alias fgrep='fgrep --color=auto'
#fi
if hash grep &> /dev/null; then
    alias grp='grep -v "grep" | grep'
fi

# Common misspellings of bash-it
alias batshit='bash-it'
alias bashit='bash-it'
alias batbsh='bash-it'
alias babsh='bash-it'
alias bash_it='bash-it'
alias bash_ti='bash-it'

alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"
