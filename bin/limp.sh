#!/bin/bash

clear
echo
echo 
echo "         ..:[ Limpeza apt-get ]:.."
echo
sudo -v
echo
sudo apt-get autoremove -y 
sudo apt-get autoclean >> /dev/null
sudo apt-get clean >> /dev/null
sudo dpkg --configure -a 
rm -rf ~/.cache/thumbnails/* >> /dev/null
echo
echo "     Limpeza Completa!"
echo
echo
echo "         Até mais!"
echo
