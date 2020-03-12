from orcsome import get_wm
from orcsome.actions import *

wm = get_wm()

# Key Handlers to be set if necessary
#wm.on_key('Shift+Mod+r')(
#    restart)

#wm.on_key('Ctrl+Alt+p')(
#    spawn_or_raise('urxvtc -name ncmpcpp -e ncmpcpp', name='ncmpcpp'))

#wm.on_key('Mod+n')(
#    spawn_or_raise('urxvtc -name mutt -e mutt', name='mutt'))

@wm.on_manage
def on_manage():
    @wm.on_property_change(wm.event_window, '_NET_WM_STATE')
    def property_was_set():
        w = wm.event_window
        if w.maximized_vert and w.maximized_horz:
            if w.decorated:
                wm.set_window_state(w, decorate=False)
        else:
            if not w.decorated:
                wm.set_window_state(w, decorate=True)