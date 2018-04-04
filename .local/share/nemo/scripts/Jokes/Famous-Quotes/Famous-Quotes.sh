#!/bin/bash

notify-send -t 8000 -i /usr/share/icons/gnome/32x32/status/info.png " " "`shuf -n1 /home/$USER/.local/share/nemo/scripts/Jokes/Famous-Quotes/.famous-quotes.txt`"
