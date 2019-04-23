#!/usr/bin/env bash
function gen_ws() { xprop -root _NET_DESKTOP_NAMES | tr ',=' '\n' | grep '"' | sed 's/"//g' ; }

WS=`echo "$(gen_ws)"  | rofi -dmenu -i -format i -p "Escolha uma Área de Trabalho:"`

if [ -n "${WS}" ]; then
    wmctrl -s "${WS}"
fi
unset WS