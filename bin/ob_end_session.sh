#!/usr/bin/env bash

if [ $(pgrep -lfc redshift) -ge 1 ] ; then
    killall redshift
fi
if [ $(pgrep -lfc redshift-gtk) -ge 1 ] ; then
    killall redshift-gtk
fi
if [ $(pgrep -lfc tint2) -ge 1 ] ; then
    killall tint2
fi
if [ $(pgrep -lfc gnome-settings-daemon) -ge 1 ] ; then
    killall gnome-settings-daemon
fi
if [ $(pgrep -lfc gnome-keyring-daemon) -ge 1 ] ; then
    killall gnome-keyring-daemon &>/dev/null
fi
if [ $(pgrep -lfc mate-settings-daemon) -ge 1 ] ; then
    killall mate-settings-daemon &>/dev/null
fi
if [ $(pgrep -lfc xautolock) -ge 1 ] ; then
    killall xautolock &>/dev/null
fi
if [ $(pgrep -lfc polkit-mate-authentication-agent-1) -ge 1 ] ; then
    killall polkit-mate-authentication-agent-1 &>/dev/null
fi
if [ $(pgrep -lfc mate-power-manager) -ge 1 ] ; then
    killall mate-power-manager &>/dev/null
fi
if [ $(pgrep -lfc cinnamon-screensaver) -ge 1 ] ; then
    killall cinnamon-screensaver &>/dev/null
fi
if [ $(pgrep -lfc mate-screensaver) -ge 1 ] ; then
    killall mate-screensaver &>/dev/null
fi
if [ $(pgrep -lfc i3lock) -ge 1 ] ; then
    killall i3lock &>/dev/null
fi
if [ $(pgrep -lfc compton) -ge 1 ] ; then
    killall compton &>/dev/null
fi
if [ $(pgrep -lfc delayctl) -ge 1 ] ; then
    killall delayctl &>/dev/null
fi
if [ $(pgrep -lfc changer.sh) -ge 1 ] ; then
    killall changer.sh &>/dev/null
fi
