#==============================================
# workaround for some stubborn distros who never loads .profile
#==============================================
export NOSTUBBORN="Y"

#===========================================
# Fix system missing $USER
#===========================================
[ -z "$USER" ] && export USER="$(whoami)"

#===========================================
# Fix system missing $HOME
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
# PATH settings
#===========================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"


#===========================================
# Export my defaults and create XDG vars if not
#===========================================
export LOCAL_BIN="${HOME}/bin"
export LOCAL_LIB="${HOME}/.local/lib"
export SXHKD_SHELL="${SHELL}"
export GIMP2_DIRECTORY="${XDG_CONFIG_HOME}/gimp"
export NO_AT_BRIDGE=1
export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_RUNTIME_DIR=/run/user/$(id -ru)
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
[ -z "$XDG_VTNR" ] && export XDG_VTNR=""
[ -z "$XDG_SESSION_ID" ] && export XDG_SESSION_ID=""
[ -z "$XDG_GREETER_DATA_DIR" ] && export XDG_GREETER_DATA_DIR=""
[ -z "$XDG_SESSION_TYPE" ] && export XDG_SESSION_TYPE=x11
[ -z "$XDG_DATA_DIRS" ] && export XDG_DATA_DIRS=/usr/share/openbox:/usr/local/share/:/usr/share/
[ -z "$XDG_SESSION_DESKTOP" ] && export XDG_SESSION_DESKTOP=""
[ -z "$XDG_SEAT_PATH" ] && export XDG_SEAT_PATH=""
[ -z "$XDG_CURRENT_DESKTOP" ] && export XDG_CURRENT_DESKTOP=""
[ -z "$XDG_SEAT" ] && export XDG_SEAT=""
[ -z "$XDG_SESSION_PATH" ] && export XDG_SESSION_PATH=""
[ -z "$XDG_CONFIG_DIRS" ] && export XDG_CONFIG_DIRS=/etc:/etc/xdg/xdg-openbox:/etc/xdg

#===========================================
# Console based text editor
#===========================================
hash nano 2> /dev/null && export EDITOR="$(type -p nano)"
[ -z "$EDITOR" ] && { hash micro 2> /dev/null && export EDITOR="$(type -p micro)"; }
[ -z "$EDITOR" ] && { hash myedit 2> /dev/null && export EDITOR="$(type -p myedit)"; }
