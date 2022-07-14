#!/bin/sh
# SPDX-License-Identifier: MIT

. /usr/local/bin/shlib/add_or_replace_in.sh
. /usr/local/bin/shlib/std.sh

env ASSUME_ALWAYS_YES=YES pkg install \
	xorg \
	drm-kmod \
	chromium

w groupmod video -m Administrator
pw groupmod wheel -m Administrator

fstab
proc           /proc       procfs  rw  0   0


sysrc -f /etc/rc.conf dbus_enable=YES
sysrc -f /etc/rc.conf sddm_enable=YES
sysrc -f /etc/rc.conf webcamd_enable=YES
sysrc -f /boot/loader.conf cuse_load=YES
sysrc -f /etc/rc.conf kld_list+=/boot/modules/i915kms.ko

#mit addorreplace
echo "exec /usr/local/bin/chrome" > ~/.xinitrc