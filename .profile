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
export CDPATH=".:$HOME:$HOME/.config/:$HOME/.local"
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# remove duplicates from the path
if [[ -x /usr/bin/awk ]]; then 
    export PATH=`echo "$PATH" | awk -F: '{for(i=1;i<=NF;i++){if(!($i in a)){a[$i];printf s$i;s=":"}}}'`;
    #export PATH="$(echo "$PATH" | /usr/bin/awk 'BEGIN { RS=":"; } { sub(sprintf("%c$", 10), ""); if (A[$0]) {} else { A[$0]=1; printf(((NR==1) ?"" : ":") $0) }}')" ; 
fi

#===========================================
# Less TERMCAP Setup
#===========================================
# enter blinking mode - red
# export LESS_TERMCAP_mb=$(printf '\e[5;31m')
# enter double-bright mode - bold, magenta
# export LESS_TERMCAP_md=$(printf '\e[1;35m')
# turn off all appearance modes (mb, md, so, us)
# export LESS_TERMCAP_me=$(printf '\e[0m')
# leave standout mode
# export LESS_TERMCAP_se=$(printf '\e[0m')
# enter standout mode - green
# export LESS_TERMCAP_so=$(printf '\e[1;32m')
# leave underline mode
# export LESS_TERMCAP_ue=$(printf '\e[0m')
# enter underline mode - blue
# export LESS_TERMCAP_us=$(printf '\e[4;34m')

#===========================================
# Less default settings
#===========================================
# F: Quit if entire file fits on first screen.
# R: Output "raw" control characters.
# X: Don't use termcap init/deinit strings.
# W: Highlight first new line after any forward movement.
# S: Chop (truncate) long lines rather than wrapping.
#===========================================
export LESS=FRXWS

#===========================================
# Export my defaults and create XDG vars if not
#===========================================
[ -z "$TERM" ] && TERM="xterm-256color"
export MOZ_REQUIRE_SIGNING=0
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
