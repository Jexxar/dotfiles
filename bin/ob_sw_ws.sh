#!/usr/bin/env bash
function switch_ws() {
    local WS=""
    WS=$(xprop -root _NET_DESKTOP_NAMES | tr ',=' '\n' | grep '"' | sed 's/"//g' | rofi -dmenu -i -format i -p "Escolha uma Área de Trabalho:")
    if [ -n "${WS}" ]; then
        wmctrl -s "${WS}"
    fi
}

switch_ws
