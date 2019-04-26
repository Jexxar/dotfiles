#!/usr/bin/env bash
set -eu

if [ -f "$HOME/bin/mylog" ]; then
    . "$HOME/bin/mylog"
fi

function snore()
{
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read ${1:+-t "$1"} -u $_snore_fd || :
}

log "Initiating autoping ..."

while 2>/dev/null ping -c3 www.google.com.br; do
    snore 30
done

log "Terminating autoping."
