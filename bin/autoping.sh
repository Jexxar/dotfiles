#!/usr/bin/env bash
set -eu

if [ -f "$HOME/bin/mycommon" ]; then
    . "$HOME/bin/mycommon"
fi

url=${1:-www.google.com.br}

log "autoping $url ..."

while 2>/dev/null ping -c3 "$url"; do
    snore 30
done

exit 0
