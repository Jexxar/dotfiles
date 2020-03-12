#!/usr/bin/env bash

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

# Only works if X is running.
if ! is_running_X ; then
    log "X server is not running";
    return 0;
fi

gxmessage   -font "Sans bold 16" "          Tem certeza que quer sair?" -nofocus -center  -borderless \
-noescape -sticky -ontop -title "Escolha uma ação" -default "Cancelar" \
-buttons "_Cancelar":1,"_Bloquear":2,"_Sair":3,"_Reiniciar":4,"_Desligar":5 >/dev/null

case $? in
    1)
        echo "Ação Cancelada"
    ;;
    2)
        exec ~/bin/mylock lock
    ;;
    3)
        dunstctl stop
        
        # Stop this session and daemon running processes.
        stop_it "polkit-gnome-authentication-agent-1" "stop"
        stop_it "gnome-keyring-daemon" "stop"
        stop_it "gnome-settings-daemon" "stop"
        stop_it "gnome-screensaver" "stop"
        stop_it "polkit-mate-authentication-agent-1" "stop"
        stop_it "mate-settings-daemon" "stop"
        stop_it "mate-power-manager" "stop"
        stop_it "mate-volume-control-applet" "stop"
        stop_it "mate-screensaver" "stop"
        stop_it "cinnamon-screensaver" "stop"
        stop_it "xscreensaver" "stop"
        stop_it "xautolock" "stop"
        stop_it "redshift-gtk" "stop"
        stop_it "redshift" "stop"
        stop_it "mylightson" "stop"
        stop_it "mywallchng" "stop"
        stop_it "tint2" "stop"
        stop_it "compton" "stop"
        log "Exiting now..."
        
        # dbus-launch cleanup
        pkill -u $USER -t `tty | cut -d '/' -f 3,4` dbus-launch
        
        openbox --exit;
        killall openbox;
    ;;
    4)
        systemctl reboot
    ;;
    5)
        systemctl poweroff
    ;;
esac