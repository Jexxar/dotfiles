#
# -binaryanomaly

cite 'about-alias'
about-alias 'Custom aliases for this installation.'

#==============================================
# Aliases - Bash Shell
#==============================================
alias bshrld='source ~/.bashrc'
alias capitalize='~/bin/capitalize.sh'
alias cd..='cd ..'
alias cp="cp -i"                          # confirm before overwriting something
alias debug="set -o nounset; set -o xtrace"
alias df='df -h'                          # human-readable sizes
alias dir='dir -lah1FX --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'

# utilizacao do disco
alias ducks='du -cks * | sort -rn | head'

alias egrep='egrep --color=auto'
alias ela='els -laH '
alias fgrep='fgrep --color=auto'
alias free='free -m'                      # show sizes in MB
alias grep='grep --color=auto'
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias launch='~/bin/launch.sh'
alias lc="colorls -sf"
alias lf='ls -lah1FX --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
alias limp='~/bin/limp.sh'
alias listeners="lsof -iTCP -sTCP:LISTEN"
alias ll='ls -lahXF --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
alias local-ip="LC_ALL=C ifconfig | grep 'inet addr' | grep -v '127.0.0.1' | cut -d: -f2 | cut -d' ' -f1"
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias ls='ls -ahXF --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto'
alias mem="watch -n 1 free -h"
alias my_disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'
alias ns='netstat -alnp --protocol=inet | grep -v ESPERANDO_FECHAR | cut -c-6,21-94 | tail '
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias openports='netstat -nape --inet'
alias ports='netstat -tulanp'
alias psa='ps -axf -o pid,%cpu,%mem,bsdtime,user,command'
alias psname='process_name'
alias pyg='pygmentize -f 256 -O style=monokai'
alias reswap='sudo swapoff -a && sudo swapon -a'
alias rm='rm -i'
alias sha1='openssl sha1'
alias toiascii="toilet -t -f ascii9"
alias toifuture="toilet -t -f future"
alias toiletlist='for i in ${TOILET_FONT_PATH:=/usr/share/figlet}/*.{t,f}lf; do j=${i##*/}; echo ""; echo "╓───── "$j; echo "╙────────────────────────────────────── ─ ─ "; echo ""; toilet -d "${i%/*}" -f "$j" "${j%.*}"; done'
alias tolower='~/bin/tolower.sh'
alias toupper='~/bin/toupper.sh'
alias upd='~/bin/upd.sh'
alias wttr="curl -4 http://wttr.in/~Curitiba"

# shortcut for iptables and pass it via sudo
# and display all rules
alias ipt='sudo /sbin/iptables'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'

## this one saved by butt so many times ##
alias wget='wget -c'

#█▓▒░ dumb tmux trix
alias tsad="printf '\033k┐(T_T)┌\033\\'"
alias tshrug="printf '\033k┐(\`-\`)┌\033\\'"
alias tlol="printf '\033k┐(^0^)┌\033\\'"

# Testar conexão com ping
alias pggl='ping -c3 www.google.com.br' # Ping ao google a cada 3 segundos
alias puol='ping -c5 www.uol.com.br' # Ping ao UOL a cada 3 segundos


# View HTTP traffic
alias sniff="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlp2s0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

alias noded="node --trace_osr --array_index_dehoisting  --trace_gc --trace_gc_verbose  --log_gc --prof --log_regexp"
alias nodec="node --crankshaft --trace_opt --use_osr --trace_osr  --trace_gc --log_regexp --log_gc --log_suspect --log_code"

alias java.debug.enable='export JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,address=5009,suspend=y"'
alias java.debug.disable='export JAVA_OPTS=""'

alias ctags='ctags --exclude={docs,cache,tiny_mce,layout} --recurse';


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
if grep --color=auto "a" "${BASH_IT}/"*.md &> /dev/null
then
  alias grep='grep --color=auto'
  export GREP_COLOR='1;33'
fi

if which gshuf &> /dev/null
then
  alias shuf=gshuf
fi

# Common misspellings of bash-it
alias shit='bash-it'
alias batshit='bash-it'
alias bashit='bash-it'
alias batbsh='bash-it'
alias babsh='bash-it'
alias bash_it='bash-it'
alias bash_ti='bash-it'

# Additional bash-it aliases for help/show
alias bshsa='bash-it show aliases'
alias bshsc='bash-it show completions'
alias bshsp='bash-it show plugins'
alias bshha='bash-it help aliases'
alias bshhc='bash-it help completions'
alias bshhp='bash-it help plugins'
alias bshsch="bash-it search"
alias bshenp="bash-it enable plugin"
alias bshena="bash-it enable alias"
alias bshenc="bash-it enable completion"
