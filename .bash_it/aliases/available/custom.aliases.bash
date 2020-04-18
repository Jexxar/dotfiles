#
# -binaryanomaly

cite 'about-alias'
about-alias 'Custom aliases for this installation.'

#==============================================
# Aliases - Bash Shell
#==============================================
alias bshrld='source ~/.bashrc'
alias cd..='cd ..'
alias cp="cp -i"                          # confirm before overwriting something
alias debug="set -o nounset; set -o xtrace"
alias df='df -h'                          # human-readable sizes
alias dir='dir -lah1FX --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'

# utilizacao do disco
alias ducks='du -cks * | sort -rn | head'

alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias lf='ls -lah1FX --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
alias ll='ls -lahXF --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
alias ls='ls -ahXF --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
alias listeners='LC_ALL=C lsof -iTCP -sTCP:LISTEN || echo "No listeners found"'
alias local-ip="LC_ALL=C ifconfig | grep 'inet addr' | grep -v '127.0.0.1' | cut -d: -f2 | cut -d' ' -f1"
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias mem="watch -n 1 free -h"
alias my_distro="$HOME/bin/distro-info -2"
alias nowtime='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
if command -v netstat > /dev/null; then
    alias ns='LC_ALL=C netstat -alnp --protocol=inet | grep -v "CLOSE_WAIT" | cut -c-6,21-94'
    alias openports='LC_ALL=C netstat -nape --inet'
    alias ports='LC_ALL=C netstat -tulanp'
fi
alias psa='ps -axf -o pid,%cpu,%mem,bsdtime,user,command'
alias psname='process_name'
alias pyg='pygmentize -f 256 -O style=monokai'
alias reswap='sudo swapoff -a && sudo swapon -a'
alias rm='rm -i'
alias sha1='openssl sha1'
alias wttr="curl -4 http://wttr.in/~Curitiba"

# shortcut for iptables and pass it via sudo
# and display all rules
alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'

## this one saved by butt so many times ##
if command -v wget > /dev/null; then
    alias wget='wget -c'
fi

#█▓▒░ dumb tmux trix
alias tsad="printf '\033k┐(T_T)┌\033\\'"
alias tshrug="printf '\033k┐(\`-\`)┌\033\\'"
alias tlol="printf '\033k┐(^0^)┌\033\\'"

# Connection testing using Ping
alias pggl='ping -c3 google.com'
alias pcdf='ping -c5 cloudflare.com'

# View HTTP traffic
if command -v ngrep > /dev/null; then
    alias sniff="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
fi
if command -v tcpdump > /dev/null; then
    alias httpdump="sudo tcpdump -i wlp2s0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
fi

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

if command -v java > /dev/null; then
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
if grep --color=auto "shell " "${BASH_IT}/"*.md &> /dev/null; then
    alias grep='grep --color=auto'
    export GREP_COLOR='1;33'
fi

# Common misspellings of bash-it
alias batshit='bash-it'
alias bashit='bash-it'
alias batbsh='bash-it'
alias babsh='bash-it'
alias bash_it='bash-it'
alias bash_ti='bash-it'
