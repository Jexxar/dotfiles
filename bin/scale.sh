#!/bin/bash

next="$1"
if [ -z "$1" ]; then
   if xrandr | grep "^HDMI1 connected"; then
      next="external"
   elif xrandr | grep "^DP1 connected"; then
      next="dp1"
   elif xrandr | grep eDP1 | grep 3200x1800; then
      next="low"
   else
      next="high"
   fi
fi

echo "Scaling to $next"

case "$next" in
l*)
   xrandr --output eDP1 --mode 1600x900_60.00
   xrandr --output HDMI1 --auto
   xrandr --output DP1 --auto
   xrandr --dpi 96
   ;;
h*)
   xrandr --output eDP1 --mode 3200x1800
   xrandr --output HDMI1 --auto
   xrandr --output DP1 --auto
   xrandr --dpi 235
   ;;
e*)
   extres="1600x1200"
   xrandr --output eDP1 --mode $extres --output HDMI1 --mode $extres --same-as eDP1
   xrandr --dpi 96
   ;;
d*)
   extres="1024x768"
   xrandr --output eDP1 --mode $extres --output DP1 --mode $extres --same-as eDP1
   xrandr --dpi 96
   ;;
esac