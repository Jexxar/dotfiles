#!/usr/bin/env bash
function title_window () { 
    xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME | cut -d '=' -f 2 | cut -b 1-2 --complement | rev | cut -c 2- | rev 2>&1
}

function title_root () {
    title_window |& grep -q 0x0
}

if title_root; then
    echo "Desktop"
else
    title_window
fi