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
export _JAVA_AWT_WM_NONREPARENTING=1
export SDL_VIDEO_X11_DGAMOUSE=0
export SWT_GTK3=0
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
[ -z "$XDG_DATA_DIRS" ] && export XDG_DATA_DIRS=/usr/share/openbox:/usr/local/share/:/usr/share/
[ -z "$XDG_CONFIG_DIRS" ] && export XDG_CONFIG_DIRS=/etc:/etc/xdg/xdg-openbox:/etc/xdg

#===========================================
# Force XDG dir locale based (/etc/xdg/user-dirs.conf not working)
#===========================================
if [ -f $XDG_CONFIG_HOME/user-dirs.dirs ]; then
    if hash xdg-user-dir 2> /dev/null; then
        export XDG_DESKTOP_DIR="$(xdg-user-dir DESKTOP)"
        export XDG_DOCUMENTS_DIR="$(xdg-user-dir DOCUMENTS)"
        export XDG_DOWNLOAD_DIR="$(xdg-user-dir DOWNLOAD)"
        export XDG_MUSIC_DIR="$(xdg-user-dir MUSIC)"
        export XDG_PICTURES_DIR="$(xdg-user-dir PICTURES)"
        export XDG_PUBLICSHARE_DIR="$(xdg-user-dir PUBLICSHARE)"
        export XDG_TEMPLATES_DIR="$(xdg-user-dir TEMPLATES)"
        export XDG_VIDEOS_DIR="$(xdg-user-dir VIDEOS)"
    fi
fi

#===========================================
# Console based text editor
#===========================================
hash nano 2> /dev/null && export EDITOR="nano"
[ -z "$EDITOR" ] && { hash micro 2> /dev/null && export EDITOR="micro"; }
[ -z "$EDITOR" ] && { hash myedit 2> /dev/null && export EDITOR="myedit"; }

#==============================================
# workaround for some stubborn distros
#==============================================
export PSTUBBORN="N"


