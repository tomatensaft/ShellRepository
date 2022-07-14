#!/bin/sh
#PDX-License-Identifier: MIT


#Set with Case - En De unw

# enable german keyboard layout
add_or_replace_in /etc/rc.conf 'keymap=' '"de.noacc.kbd"'
kbdcontrol -l de.noacc.kbd