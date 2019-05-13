#!/usr/bin/env bash
stty -echo
printf "Password: "
read PASSWORD
stty echo
printf "%s $PASSWORD\n"
unset PASSWORD