#!/usr/bin/env python
# -*- coding: utf-8 -*-

import getopt
import getpass
import os
import sys

class bl_exit:
    def disable_buttons(self):
        self.cancel.set_sensitive(False)
        self.logout.set_sensitive(False)
        self.suspend.set_sensitive(False)
        self.reboot.set_sensitive(False)
        self.shutdown.set_sensitive(False)

    def cancel_action(self,btn):
        self.disable_buttons()
        gtk.main_quit()

    def logout_action(self,btn):
        self.disable_buttons()
        self.status.set_label("Exiting Openbox, please standby...")
        logout()
        gtk.main_quit()

    def suspend_action(self,btn):
        self.disable_buttons()
        self.status.set_label("Suspending, please standby...")
        suspend()
        gtk.main_quit()

    def reboot_action(self,btn):
        self.disable_buttons()
        self.status.set_label("Rebooting, please standby...")
        reboot()

    def shutdown_action(self,btn):
        self.disable_buttons()
        self.status.set_label("Shutting down, please standby...")
        poweroff()

    def create_window(self):
        self.window = gtk.Window()
        title = "Log out " + getpass.getuser() + "? Choose an option:"
        self.window.set_title(title)
        self.window.set_border_width(5)
        self.window.set_size_request(500, 80)
        self.window.set_resizable(False)
        self.window.set_keep_above(True)
        self.window.stick
        self.window.set_position(1)
        self.window.connect("delete_event", gtk.main_quit)
        windowicon = self.window.render_icon(gtk.STOCK_QUIT, gtk.ICON_SIZE_DIALOG)
        self.window.set_icon(windowicon)

        #Create HBox for buttons
        self.button_box = gtk.HBox()

        #Cancel button
        self.cancel = gtk.Button(stock = gtk.STOCK_CANCEL)
        self.cancel.set_border_width(4)
        self.cancel.connect("clicked", self.cancel_action)
        self.button_box.pack_start(self.cancel)

        #Cancel key (Escape)
        accelgroup = gtk.AccelGroup()
        self.key, self.mod = gtk.accelerator_parse('Escape')
        accelgroup.connect_group(self.key, self.mod, gtk.ACCEL_VISIBLE, gtk.main_quit)
        self.window.add_accel_group(accelgroup)

        #Logout button
        self.logout = gtk.Button("_Log out")
        self.logout.set_border_width(4)
        self.logout.connect("clicked", self.logout_action)
        self.button_box.pack_start(self.logout)

        #Suspend button
        self.suspend = gtk.Button("_Suspend")
        self.suspend.set_border_width(4)
        self.suspend.connect("clicked", self.suspend_action)
        self.button_box.pack_start(self.suspend)

        #Reboot button
        self.reboot = gtk.Button("_Reboot")
        self.reboot.set_border_width(4)
        self.reboot.connect("clicked", self.reboot_action)
        self.button_box.pack_start(self.reboot)

        #Shutdown button
        self.shutdown = gtk.Button("_Power off")
        self.shutdown.set_border_width(4)
        self.shutdown.connect("clicked", self.shutdown_action)
        self.button_box.pack_start(self.shutdown)

        #Create HBox for status label
        self.label_box = gtk.HBox()
        self.status = gtk.Label()
        self.label_box.pack_start(self.status)

        #Create VBox and pack the above HBox's
        self.vbox = gtk.VBox()
        self.vbox.pack_start(self.button_box)
        self.vbox.pack_start(self.label_box)

        self.window.add(self.vbox)
        self.window.show_all()

    def __init__(self):
        self.create_window()

def send_dbus(string):
    dbus_send = "dbus-send --print-reply --system --dest=org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.{} boolean:true"
    os.system(dbus_send.format(string))

def logout():
    os.system("openbox --logout")

def suspend():
    os.system("bl-lock")
    send_dbus("Suspend")

def reboot():
    send_dbus("Reboot")

def poweroff():
    send_dbus("Poweroff")

def print_usage(status):
    print ("bl-exit: usage:\n" \
        "  -h, --help      show this message and exit\n" \
        "  -l, --logout    log out from openbox\n" \
        "  -s, --suspend   suspend the system\n" \
        "  -r, --reboot    reboot the system\n" \
        "  -p, --poweroff  power the system down")
    sys.exit(status)

if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hlsrp", ["help","logout","suspend","reboot","poweroff"])
    except getopt.GetoptError:
        print_usage(1)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print_usage(0)
            sys.exit(0)
        elif opt in ("-l", "--logout"):
            logout()
            sys.exit(0)
        elif opt in ("-s", "--suspend"):
            suspend()
            sys.exit(0)
        elif opt in ("-r", "--reboot"):
            reboot()
            sys.exit(0)
        elif opt in ("-p", "--poweroff"):
            poweroff()
            sys.exit(0)
    # Only import the following graphical modules
    # when no runtime options are specified.
    import gtk
    import pygtk
    pygtk.require('2.0')

    go = bl_exit()
    gtk.main()