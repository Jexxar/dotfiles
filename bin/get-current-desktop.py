#!/usr/bin/env python

import sys
from xpybutil.compat import xproto
import xpybutil
import xpybutil.event as event
import xpybutil.ewmh as ewmh

names = ewmh.get_desktop_names().reply()
desk = ewmh.get_current_desktop().reply()

print "-- desktop name --"
print names[desk] if desk < len(names) else desk
print "-- desktop index --"
print desk

try:
    awin = ewmh.get_active_window().reply()
    wdesk = ewmh.get_wm_desktop(awin).reply()
    visibles = ewmh.get_visible_desktops().reply() or [desk]
    print "-- win ID --"
    print awin
    print "-- desktop que contem a win ID --"
    print wdesk
    print "-- desktop visiveis --"
    print visibles
    
    if wdesk is not None and wdesk not in visibles:
        ewmh.request_current_desktop_checked(wdesk).check()
    ewmh.request_active_window_checked(awin, source=1).check()
except xproto.BadWindow:
    print >> sys.stderr, '%d no longer exists' % awin
