#===========================================
# Fix systems missing $USER
#===========================================
[ -z "$USER" ] && export USER="$(whoami)"

#===========================================
# Fix systems missing $HOME
#===========================================
[ -z "$HOME" ] && export HOME="$(dirname ~/1)"

#===========================================
# Don't want coredumps.
#===========================================
ulimit -S -c 0

#===========================================
# Defube manpager most or less
#===========================================
if [ -f "/usr/bin/most" ]; then
    export MANPAGER="/usr/bin/most"
else
    export MANPAGER="/usr/bin/less"
fi

#===========================================
# Prevents scroll bars misbehaviour
#===========================================
#export GTK_OVERLAY_SCROLLING=0
#gdbus call --session --dest org.freedesktop.DBus --object-path /org/freedesktop/DBus --method org.freedesktop.DBus.UpdateActivationEnvironment '{"GTK_OVERLAY_SCROLLING": "0"}'

#===========================================
# QT style override
#===========================================
export QT_STYLE_OVERRIDE=GTK+

#===========================================
# Define script for sudo_askpass
#===========================================
export SUDO_ASKPASS="${HOME}/bin/askpw"

#===========================================
# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
#===========================================
export PYTHONIOENCODING='UTF-8';

#===========================================
# Make Pipemenus without icons for faster loading
#===========================================
export MYPIPM_ICONS='n'

#===========================================
# OS variables
#===========================================
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1
grep -q "Microsoft" /proc/version 2>/dev/null && export UBUNTU_ON_WINDOWS=1

#===========================================
# Prefer locale language pt_BR and use UTF-8.
#===========================================
export LANG='pt_BR.UTF-8';
export LC_ALL='pt_BR.UTF-8';

#===========================================
# for cache function settings
#===========================================
export CACHE_DIR="/tmp"

#===========================================
# PATH settings
#===========================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
[ -z "$HOME" ] && export PATH="~/bin:~/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"

#===========================================
# Don't check mail when opening terminal.
#===========================================
unset MAILCHECK

#===========================================
# Change this to your console based IRC client of choice.
#===========================================
export IRC_CLIENT='irssi'

#===========================================
# Set this to the command you use for todo.txt-cli
#===========================================
#export TODO="t"

#===========================================
# Default console editor
#===========================================
export EDITOR="/bin/nano"
#export VISUAL="/bin/nano"

#===========================================
# git author data comes from .gitconfig and is saved as environment variables
# that are sent to ssh connections to maintain you identity across machines
#===========================================
export GIT_HOSTING='jexxar@github.com'
export GIT_AUTHOR_NAME=`git config user.name`
export GIT_AUTHOR_EMAIL=`git config user.email`
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

#===========================================
# Java stuff
#===========================================
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export JAVA_HOME="/usr/lib/jvm/default-java"
export CLASSPATH="$JAVA_HOME/lib":$CLASSPATH
export PATH="$JAVA_HOME/bin":$PATH
export MANPATH="$JAVA_HOME/man":$MANPATH

#===========================================
# Local settings
#===========================================
export LOCAL_BIN="${HOME}/.local/bin"
export LOCAL_LIB="${HOME}/.local/lib"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_RUNTIME_DIR=/run/user/$(id -ru)
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export SXHKD_SHELL="/usr/bin/bash"
export GIMP2_DIRECTORY="${XDG_CONFIG_HOME}/gimp"

#===========================================
# Reuse ssh-agent and/or gpg-agent between logins for some keys
#===========================================
if [ $UID -ne "0" ]; then
    [ -f $HOME/.ssh/githubkey_rsa ] && /usr/bin/keychain --eval --quiet -Q $HOME/.ssh/githubkey_rsa;
    [ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh;
    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg;
fi
