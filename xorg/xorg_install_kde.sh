#!/bin/sh
# SPDX-License-Identifier: MIT

. /usr/local/bin/shlib/add_or_replace_in.sh
. /usr/local/bin/shlib/std.sh

env ASSUME_ALWAYS_YES=YES pkg install \
	xorg-minimal \
	drm-kmod \
	plasma5-plasma \
	kate \
	konsole \
	sddm \
	plasma5-sddm-kcm \
	firefox

gconf2 \
	git-gui \
	#gtk3 \
	kde-baseapps \
	#kf5-frameworks \

	snappy \
	#speech-dispatcher \
	#virtualbox-ose-additions \
	wget \
	xterm
    tigervnc
    vscode
    thunderbird


    # configure driver, login and window manager
pw groupmod video -m Administrator
pw groupmod wheel -m Administrator

fstab
proc           /proc       procfs  rw  0   0
cat << EOF > /u Test cat or use ech
echo 'proc           /proc       procfs  rw  0   0'

if grep -q 'proc' /etc/fstab


sysrc -f /etc/rc.conf dbus_enable=YES
sysrc -f /etc/rc.conf sddm_enable=YES
sysrc -f /etc/rc.conf webcamd_enable=YES
sysrc -f /boot/loader.conf cuse_load=YES
sysrc -f /etc/rc.conf kld_list+=/boot/modules/i915kms.ko

#mit addorreplace
echo "exec ck-launch-session startkde" > ~/.xinitrc

# disable baloo for better performance on low-end devices
su -l Administrator -c "balooctl disable"