#===========================================
# Fix systems missing $USER
#===========================================
[ -z "$USER" ] && export USER="$(whoami)"

#===========================================
# Fix systems missing $HOME
#===========================================
[ -z "$HOME" ] && export HOME="$(dirname ~/1)"

#===========================================
# OS variables
#===========================================
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1
grep -q "Microsoft" /proc/version 2>/dev/null && export UBUNTU_ON_WINDOWS=1

#===========================================
# Prefer locale & language pt_BR and use UTF-8.
#===========================================
export LANG='pt_BR.UTF-8';
export LC_ALL='pt_BR.UTF-8';

#===========================================
# PATH settings
#===========================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
[ -z "$HOME" ] && export PATH="~/bin:~/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"

#===========================================
# Local settings
#===========================================
export LOCAL_BIN="${HOME}/.local/bin"
export LOCAL_LIB="${HOME}/.local/lib"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_RUNTIME_DIR=/run/user/$(id -ru)
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export SXHKD_SHELL="${SHELL}"
export GIMP2_DIRECTORY="${XDG_CONFIG_HOME}/gimp"

#===========================================
# Reuse ssh-agent and/or gpg-agent between logins for some keys
#===========================================
if [ $UID -ne "0" ]; then
    [ -f $HOME/.ssh/githubkey_rsa ] && /usr/bin/keychain --eval --quiet -Q $HOME/.ssh/githubkey_rsa;
    [ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh;
    [ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg;
fi
