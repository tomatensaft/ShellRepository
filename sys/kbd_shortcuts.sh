#!/bin/sh
#PDX-License-Identifier: MIT


# reenable keyboard shortcuts f.e. "CTRL+ALT+DEL"
sysctl kern.vt.kbd_debug=1
sysctl kern.vt.kbd_halt=1
sysctl kern.vt.kbd_panic=1
sysctl kern.vt.kbd_poweroff=1
sysctl kern.vt.kbd_reboot=1

# make the above changes permanent
add_or_replace_in /etc/sysctl.conf 'kern.vt.kbd_debug=' '"1"'
add_or_replace_in /etc/sysctl.conf 'kern.vt.kbd_halt=' '"1"'
add_or_replace_in /etc/sysctl.conf 'kern.vt.kbd_panic=' '"1"'
add_or_replace_in /etc/sysctl.conf 'kern.vt.kbd_poweroff=' '"1"'
add_or_replace_in /etc/sysctl.conf 'kern.vt.kbd_reboot=' '"1"'