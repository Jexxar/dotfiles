# ~/.bash_logout: executed by bash(1) ONLY when login shell exits.

# dbus-launch cleanup
pkill -u $USER -t `tty | cut -d '/' -f 3,4` dbus-launch

# when leaving the console clear the screen to increase privacy
if [ $SHLVL -eq 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

clear &> /dev/null
