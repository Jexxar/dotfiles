#!/usr/bin/env bash

clear
echo
sudo -v
echo
echo "Filter table:"
sudo iptables -t filter -vL

echo "Nat table:"
sudo iptables -t nat -vL

echo "Mangle table:"
sudo iptables -t mangle -vL

echo "Raw table:"
sudo iptables -t raw -vL

echo "Security table:"
sudo iptables -t security -vL

echo
echo "All rules in all tables printed"