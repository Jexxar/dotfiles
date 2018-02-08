#!/bin/bash 
gxmessage -font "Sans bold 16" "          Tem certeza que quer sair?" -center  -borderless -noescape -sticky -ontop -title "Escolha uma ação" -default "Cancelar" -buttons "_Cancelar":1,"_Bloquear":2,"_Sair":3,"_Reiniciar":4,"_Desligar":5 >/dev/null 
case $? in 
  1) 
     echo "Ação Cancelada";; 
  2) 
     cinnamon-screensaver-command -l;; 
  3) 
     openbox --exit;
     killall openbox*;
     killall tint2;
     killall gnome-settings-daemon;
     killall mate-settings-daemon
     killall xautolock;
     killall polkit-mate-authentication-agent-1;
     killall mate-power-manager; 
     killall cinnamon-screensaver ;; 
  4) 
     reboot ;; 
  5) 
     shutdown -h now;; 
esac