#!/usr/bin/python
# coding=utf-8
# Usage: gnome-inhibit <command-line>
# Example: gnome-inhibit mpv video.mp4

import subprocess
import dbus
import sys
import os

bus = dbus.SessionBus()
proxy = bus.get_object('org.freedesktop.ScreenSaver','/org/freedesktop/ScreenSaver')
iface = dbus.Interface(proxy, 'org.freedesktop.ScreenSaver')
cookie = iface.Inhibit(sys.argv[1], "gnome-inhibit")
print("Inhibiting screensaver (pid: %d)" % os.getpid())
print("Executing: %s" % subprocess.list2cmdline(sys.argv[1:]))

subprocess.check_call(sys.argv[1:])