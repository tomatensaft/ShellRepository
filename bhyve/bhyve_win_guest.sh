#!/bin/sh
# SPDX-License-Identifier: MIT

echo Start

doas bhyve -c 2 -m 2G \
-A -H -S -w \
-l bootrom,/usr/local/share/uefi-firmware/BHYVE_BHF_UEFI.fd \
-s 0:0,hostbridge \
-s 1:0,ahci-hd,/home/Administrator/windows10.img \
-s 7,passthru,0/2/0,igd \
-s 9:0,virtio-net,tap0 \
-s 10:0,ahci-cd,/home/Administrator/virtio-win-0.1.217.iso  \
-s 29,fbuf,tcp=0.0.0.0:5900,w=1024,h=768,wait \
-s 30,xhci,tablet \
-s 31:0,lpc \
win10-vm