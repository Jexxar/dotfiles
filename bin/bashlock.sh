#!/bin/bash

if [ -f "$HOME/bin/mylog" ]; then
    . "$HOME/bin/mylog"
fi

MAXRETRIES=5
RETRYSLEEP=10

function onexit() {
    return
}

#checkpassword() {
#    local PASS=${2//$/\\$}
#    expect << EOF >/dev/null
#spawn su $1 -c "exit"
#expect "Password:"
#send "${PASS}\r"
#expect eof
#catch wait result
#exit [lindex \$result 3]
#EOF
#}

function checkpassword() {
    su $1 -c "true" || false
}

function header() {
    local RETRIES=${1}
    clear
    echo ""
    echo ""
    echo ""
    echo ""
    if [ "${RETRIES}" -ne 0 ]; then
        echo "Locked by ${USER} (${RETRIES} failed login attempts)"
        log "Locked by ${USER} (${RETRIES} failed login attempts)"
    else
        echo "Locked by ${USER}"
    fi
}

function authenticate() {
    local RETRY=0
    while true; do
        header $RETRY
        checkpassword ${USER} 
        if [ "$?" -eq 0 ]; then
            echo "Welcome back!"
            echo ""
            exit 0
        else
            RETRY=$((RETRY+1))
            header $RETRY
            echo "authentication failed!"
            echo ""
            log "authentication failed!"
            if [ "${RETRY}" -ge "${MAXRETRIES}" ]; then
                RETRY=0
                echo "sleeping for ${RETRYSLEEP}"
                sleep ${RETRYSLEEP}
                header $RETRY
            fi
        fi
    done
}

trap onexit 1 2 3 15 18 20 ERR
authenticate
unset MAXRETRIES
unset RETRYSLEEP
