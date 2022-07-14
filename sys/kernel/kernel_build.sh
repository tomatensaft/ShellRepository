#!/bin/sh
# SPDX-License-Identifier: MIT

cd /usr/src/sys/`uname -m`/conf
cp GENERIC NAN_FIRST_BUILD
cd /usr/src
make buildkernel KERNCONF="NAN_FIRST_BUILD"
make installkernel KERNCONF="NAN_FIRST_BUILD"
reboot
uname -a

mv /boot/kernel.old /boot/kernel.good   
mv /boot/kernel /boot/kernel.bad
mv /boot/kernel.good /boot/kernel