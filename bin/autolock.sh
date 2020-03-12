#!/usr/bin/env bash
set -eu

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
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
    xset q &>/dev/null && return 0;
    return 1
}

# Return 0 if suspend is acceptable.
function suspend_ok() {
    [ -n "$(2>/dev/null mpc current)" ] && return 1
    return 0
}

case "$cmd" in
  lock)
    log "Locking screen now..."
    dunstctl stop

    # Fork both i3lock and its monitor to avoid blocking xautolock.
    # this must be the last command, and it must be 'non forking', as expected by 'xautolock'
    ~/bin/lock -gpf Comic-Sans-MS -- scrot -z &
    
    pid="$!"
    log "Waiting for PID $pid to end..."
    while 2>/dev/null kill -0 "$pid"; do
      sleep 1
    done

    dunstctl resume
    ;;

  notify)
    # Notification should not be issued while locked even if dunst is paused.
    locked && exit

    log "Sending notification."
    # grep finds either Xautolock.notify or Xautolock*notify
    secs="$(xrdb -query | grep -m1 '^Xautolock.notify' | cut -f2)"
    test -n "$secs" && secs="Locking in $secs seconds"

    notify-send --urgency="normal" --app-name="xautolock" \
      --icon="$(iconPath system-lock-screen)" \
      -- "Screen Lock" "$secs"
    
    stop_it "gnome-screensaver" "stop"
    stop_it "mate-screensaver" "stop"
    stop_it "cinnamon-screensaver" "stop"
    stop_it "xscreensaver" "stop"
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