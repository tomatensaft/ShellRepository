#!/bin/sh
# SPDX-License-Identifier: MIT


pkg install uefi-edk2-bhyve-bhf

iso_file="$(pwd)/debian-installer.iso"
fetch -o "${iso_file}" https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso

vm_disk="zroot/debian-vm_disk0"
doas zfs create -V 10G -o volmode=dev ${vm_disk}

nic="igb1" # adjust according to you local setup
vnc_port="5900"
tap="$(doas ifconfig tap create)"
bridge="$(doas ifconfig bridge create)"
doas sysctl net.link.tap.up_on_open=1
doas ifconfig ${bridge} addm ${tap} addm ${nic} up
doas sysctl net.link.bridge.pfil_member=0
temp_firewall_rules="$(mktemp)"
echo "pass in quick on ${bridge}" >> "${temp_firewall_rules}"
echo "pass in quick proto tcp to port ${vnc_port}" >> "${temp_firewall_rules}"
doas pfctl -a bhf/bhyve/debian-vm -f "${temp_firewall_rules}"

dias kldload -n vmm


doas bhyve -c 2 -m 2G \
-A -H \
-l bootrom,/usr/local/share/uefi-firmware/BHYVE_BHF_UEFI.fd \
-s 0:0,hostbridge \
-s 1:0,virtio-blk,/dev/zvol/"${vm_disk}" \
-s 2:0,virtio-net,"${tap}" \
-s 10:0,ahci-cd,"${iso_file}" \
-s 29,fbuf,tcp=0.0.0.0:"${vnc_port}",w=1024,h=768,wait \
-s 30,xhci,tablet \
-s 31:0,lpc \
debian-vm



-Start
doas bhyve -c 2 -m 2G \
-A -H \
-l bootrom,/usr/local/share/uefi-firmware/BHYVE_BHF_UEFI.fd \
-s 0:0,hostbridge \
-s 1:0,virtio-blk,/dev/zvol/"${vm_disk}" \
-s 2:0,virtio-net,"${tap}" \
-s 10:0,ahci-cd,"${iso_file}" \
-s 29,fbuf,tcp=0.0.0.0:"${vnc_port}",w=1024,h=768,wait \
-s 30,xhci,tablet \
-s 31:0,lpc \
debian-vm


doas bhyvectl --vm=debian-vm --destroy

doas ifconfig ${bridge} deletem ${tap} deletem ${nic}
doas ifconfig ${bridge} down
doas ifconfig ${bridge} destroy
doas ifconfig ${tap} destroy
doas pfctl -a bhf/bhyve/debian-vm -f /dev/null
doas rm "${temp_firewall_rules}"