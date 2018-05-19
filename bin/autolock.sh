#!/bin/bash
set -eu

if [ -f "$HOME/bin/mylog" ]; then
    . "$HOME/bin/mylog"
fi

# This script is intended to be run as the xautolock locker and notifier.
# It requires i3lock, and dunst is optional.

# Copy or link this script as /usr/bin/slock to let xfce4-session run it.
if [ "$(basename "$0")" = "slock" ]; then
    cmd=lock
else
    cmd=${1:-lock}
fi

function is_running_X(){
    if ! xset q &>/dev/null; then
        return 1
    fi
    return 0
}

# Is the screen already locked?
function locked() { pkill -0 --euid "$(id -u)" --exact i3lock; }

# Return 0 if suspend is acceptable.
function suspend_ok() {
    [ -n "$(2>/dev/null mpc current)" ] && return 1
    return 0
}

# Control the dunst daemon, if it is running.
function dunst() {
    pkill -0 --exact dunst || return 0

    case ${1:-} in
        stop)
            log "Stopping notifications and locking screen."
            pkill -USR1 --euid "$(id -u)" --exact dunst
            ;;
        resume)
            log "...Resuming notifications."
            pkill -USR2 --euid "$(id -u)" --exact dunst
            ;;
        *)
            echo "dunst argument required: stop or resume"
            return 1
            ;;
    esac
}

case "$cmd" in
  lock)
    log "Locking screen now..."
    dunst stop

    # Fork both i3lock and its monitor to avoid blocking xautolock.
    # this must be the last command, and it must be 'non forking', as expected by 'xautolock'
    /home/usuario/bin/lock -gpf Comic-Sans-MS -- scrot -z &
    
    pid="$!"
    log "Waiting for PID $pid to end..."
    while 2>/dev/null kill -0 "$pid"; do
      sleep 1
    done

    dunst resume
    ;;

  notify)
    # Notification should not be issued while locked even if dunst is paused.
    locked && exit

    log "Sending notification."
    # grep finds either Xautolock.notify or Xautolock*notify
    secs="$(xrdb -query | grep -m1 '^Xautolock.notify' | cut -f2)"
    test -n "$secs" && secs="Locking in $secs seconds"

    notify-send --urgency="normal" --app-name="xautolock" \
      --icon='/usr/share/icons/Adwaita/48x48/actions/system-lock-screen.png' \
      -- "Screen Lock" "$secs"
    
    if [ $(pgrep -lfc cinnamon-screensaver) -ge 1 ] ; then
      while 2>/dev/null killall cinnamon-screensaver; do
        sleep 1
      done
    fi

    if [ $(pgrep -lfc mate-screensaver) -ge 1 ] ; then
      while 2>/dev/null killall mate-screensaver; do
        sleep 1
      done
    fi
    ;;

  suspend)
    if suspend_ok; then
      log "Suspending system."
      systemctl suspend
    else
      log "Deferring suspend."
    fi
    ;;

  off)
    # if "off" is given as parameter, then spawn a new thread to turn off the screen
   sleep 2 && xset dpms force off &
    ;;
    
  debug)
    log "$@"
    ;;

  *)
    log "Unrecognized option: $1"
esac