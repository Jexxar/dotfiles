#!/usr/bin/env bash

clear
echo
echo 
echo "         ..:[ Update/Upgrade apt-get ]:.."
echo
sudo -v
echo
echo "        Atualizando o cache dos repositorios..."
echo
sudo apt-get update -o Acquire::CompressionTypes::Order::=gz 
echo
echo "        Fazendo upgrade..."
echo
sudo apt upgrade && sudo apt dist-upgrade 
echo
echo "        Saneando o ambiente..."
echo
sudo apt-get -f install -y
sudo dpkg --configure -a
echo
echo "        Update Completo!"
echo
echo
echo "        Até mais!"
echo
# end script
