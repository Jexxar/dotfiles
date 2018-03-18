#!/bin/bash

case $1 in
up)
  amixer set Master unmute > /dev/null
  amixer set Master 5%+ >/dev/null
  ;;
down)
  amixer set Master unmute > /dev/null
  amixer set Master 5%- >/dev/null
  ;;
mute)
  amixer set Master mute > /dev/null
  amixer -Dhw:1 set Master mute > /dev/null
  ;;
status)
  amixer get Master | tail -n 1 | awk '{if ($6 ~ /on/) { gsub(/[\[\]]/, "", $5); print $5; } else print "off" }'
  ;;
*)
  echo "Wrong parameters"
  ;;
esac

exit 0