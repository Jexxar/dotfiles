#!/usr/bin/env bash
set -eu

if [ -f "$HOME/bin/mylog" ]; then
    . "$HOME/bin/mylog"
fi

log "Initiating autoping ..."

while 2>/dev/null ping -c3 www.google.com.br; do
    sleep 30
done

log "Terminating autoping."
