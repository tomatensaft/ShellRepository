#!/bin/sh
# SPDX-License-Identifier: MIT

#Bhyve Init Config

echo Start Bhyve Init

ifconfig tap create
ifconfig bridge create
sysctl net.link.tap.up_on_open=1
ifconfig bridge0 addm tap0 addm em1 up
sysctl net.link.bridge.pfil_member=0

#devctl detach pci0:0:2:0
#devctl set driver pci0:0:2:0 ppt