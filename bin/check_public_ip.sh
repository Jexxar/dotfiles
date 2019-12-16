#!/usr/bin/env bash

#Script to report public IP address change
#By: Ronny L. Bull

TO="youremail@yourdomain.com"
FROM="alerts@yourdomain.com"

#The file that contains the current pubic IP
EXT_IP_FILE="/tmp/.ipaddress"

function external_ip ()
{
    local list=("ifconfig.me" "http://myip.dnsomatic.com/" "http://checkip.dyndns.com/" "http://checkip.dyndns.org/");
    local res=""
    local url=""
    for url in ${list[*]};
    do
        res=$(curl -s "${url}");
        if [ $? -eq 0 ]; then
            break;
        fi;
    done;
    res=$(echo "$res" | grep -Eo '[0-9\.]+');
    echo -e "$res"
}

function has_sendmail
{
    pgrep sendmail && true
    if [ $? -eq 0 ]; then
        return 0;
    fi;
    return 1;
}

#Send a message if it possible
function send_msg
{
    if has_sendmail; then
        echo "$*" | sendmail -f ${FROM} ${TO}
    else
        echo "$*"
    fi
}

#Get the current public IP
CURRENT_IP=$(external_ip)
echo "Current ip is $CURRENT_IP"

#Check file for previous IP address
if [ -f $EXT_IP_FILE ]; then
    KNOWN_IP=$(awk '{ print $0 }' $EXT_IP_FILE)
else
    KNOWN_IP=
fi

#See if the IP has changed
if [ "$CURRENT_IP" != "$KNOWN_IP" ]; then
    echo "$CURRENT_IP" > "$EXT_IP_FILE"
    
    #If so send an alert
    send_msg "Subject: The IP Address at home has changed
    The IP address at home has been changed to $CURRENT_IP"
    
    logger -t ipcheck -- IP changed to "$CURRENT_IP"
else
    #If not just report that it stayed the same
    send_msg "Subject: The IP Address at home is the same
    The IP address at home stayed the same $CURRENT_IP"
    logger -t ipcheck -- NO IP change
fi

