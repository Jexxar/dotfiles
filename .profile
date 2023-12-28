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

# remove duplicates from the path
if [[ -x /usr/bin/awk ]]; then 
    export PATH=`echo "$PATH" | awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}'`;
    #export PATH="$(echo "$PATH" | /usr/bin/awk 'BEGIN { RS=":"; } { sub(sprintf("%c$", 10), ""); if (A[$0]) {} else { A[$0]=1; printf(((NR==1) ?"" : ":") $0) }}')" ; 
fi

#===========================================
# Gtk3-nocsd workaround settings
#===========================================
export GTK_CSD=0
if hash locate 2> /dev/null; then
    _nocsdpath="$(locate libgtk3-nocsd.so.0)"
elif hash mlocate 2> /dev/null; then
    _nocsdpath="$(mlocate libgtk3-nocsd.so.0)"
elif [ -f /usr/lib/x86_64-linux-gnu/libgtk3-nocsd.so.0 ]; then
    _nocsdpath="/usr/lib/x86_64-linux-gnu/libgtk3-nocsd.so.0"
else
    _nocsdpath=""
fi
[ $? -ne 0 ] && _nocsdpath=""
if [ -n "$_nocsdpath" ]; then
    echo $LD_PRELOAD | grep -q "libgtk3-nocsd\.so\.0"
    if [ $? -ne 0 ]; then
        export LD_PRELOAD=${_nocsdpath}
    fi
    echo $STARTUP | grep -q "libgtk3-nocsd\.so\.0"
    if [ $? -ne 0 ]; then
        export STARTUP="env LD_PRELOAD=$_nocsdpath $STARTUP"
    fi
fi
unset _nocsdpath

#===========================================
# Export my defaults and create XDG vars if not
#===========================================
[ -z "$TERM" ] && TERM="xterm-256color"
export GTK_OVERLAY_SCROLLING=0
export MYPIPM_ICONS='n'
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
# Force XDG dir locale based (when /etc/xdg/user-dirs.conf not working)
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
[ -z "$VISUAL" ] && { hash myedit 2> /dev/null && export VISUAL="myedit"; }

#==============================================
# workaround for some stubborn distros
#==============================================
export PSTUBBORN="N"
