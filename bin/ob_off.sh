#!/bin/bash 
gxmessage -font "Sans bold 16" "          Tem certeza que quer sair?" -center  -borderless -noescape -sticky -ontop -title "Escolha uma ação" -default "Cancelar" -buttons "_Cancelar":1,"_Bloquear":2,"_Sair":3,"_Reiniciar":4,"_Desligar":5 >/dev/null 
case $? in 
    1) 
        echo "Ação Cancelada"
        ;; 
    2) 
        mate-screensaver-command -l
        ;; 
    3) 
        if [ $(pgrep -lfc gnome-keyring-daemon) -ge 1 ] ; then
            while 2>/dev/null killall gnome-keyring-daemon; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc tint2) -ge 1 ]; then 
            while 2>/dev/null killall tint2;do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc gnome-settings-daemon) -ge 1 ]; then 
            while 2>/dev/null killall gnome-settings-daemon; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc mate-settings-daemon) -ge 1 ]; then 
            while 2>/dev/null killall mate-settings-daemon; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc xautolock) -ge 1 ]; then 
            while 2>/dev/null killall xautolock; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc polkit-mate-authentication-agent-1) -ge 1 ]; then 
            while 2>/dev/null killall polkit-mate-authentication-agent-1; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc mate-power-manager) -ge 1 ]; then 
            while 2>/dev/null killall mate-power-manager; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc gnome-screensaver) -ge 1 ]; then 
            while 2>/dev/null killall gnome-screensaver; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc xscreensaver) -ge 1 ]; then 
            while 2>/dev/null killall xscreensaver; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc cinnamon-screensaver) -ge 1 ]; then 
            while 2>/dev/null killall cinnamon-screensaver; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc redshift-gtk) -ge 1 ]; then 
            while 2>/dev/null killall redshift-gtk; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc lightsOn.sh) -ge 1 ]; then 
            while 2>/dev/null killall lightsOn.sh; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc changer.sh) -ge 1 ]; then 
            while 2>/dev/null killall changer.sh; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc mate-screensaver) -ge 1 ]; then 
            while 2>/dev/null killall mate-screensaver; do
                sleep 0.2
            done
        fi
        if [ $(pgrep -lfc compton) -ge 1 ]; then 
            while 2>/dev/null killall compton; do
                sleep 0.2
            done
        fi
        
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