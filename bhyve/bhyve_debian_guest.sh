#!/bin/sh
# SPDX-License-Identifier: MIT


#Install Debian Bhyve Guest

#Print Header
printf "-----------------------------"
printf "|                           |"
printf "|  Exmaple Bhyve Debian     |"
printf "|  Adjust Params in Script  |"
printf "|                           |"
printf "-----------------------------"

#Check Root
if [ $(id -u) -ne 0 ]; then
	printf "Usage: run '$0' as root.\n"
	return 1
fi

#Check Bhyve
if command -v bhyve >/dev/null 2>&1 ; then
    printf "Bhyve Grub Program Found...\n"
else
    printf "Bhyve Grub Program Not Found...\n"
    exit 1
fi 

#Check Grub Uefi Loader
if pkg info grub2-bhyve | grep bhyve; then
    printf "Bhyve Grub Uefi Loader Found...\n"
else
    pkg install -y grub2-bhyve 
fi

#Check Kernel Modules
if kldstat | grep vmm; then
    printf "Kernel Module vmm found"
else
    printf "Load Kernel module vmm"
    kldload vmm
    #exit 1
fi

#Params - Adjust if needed
iso_file="$(pwd)/debian-installer.iso"
debian_file= "debian-11.4.0-amd64-netinst.iso"
vm_disk="zroot/debian-vm_disk0"
vnc_port="5900"
nic="wlan0" 

#Get IsoFiles
printf "Fetch Debian Iso File ${debian_file}..\n"
fetch -o "${iso_file}" "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/${debian_file}"

#Check zroot disk exists
if zfs list | grep vm_disk; then
    printf "zfs disk found"
else    
    printf "zfs create disk ${vm_disk}"    
    zfs create -V 10G -o volmode=dev ${vm_disk}
fi

#Load Nic
. bhyve_net_config.sh $nic
if [ $? -eq 1]; then
    printf "Problem Creating Nic Bridge"
    exit 1
else
    create_bridge    
fi

return 0;

#Start Bhyve Debian Guest
#2 Cores / 2 GigRAM / VirtIO / Uefi
install_debian_guest() 
{
    bhyve -c 2 -m 2G \
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
}

start_debian_guest() 
{
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
}

destroy_debian_guest() 
{
    bhyvectl --vm=debian-vm --destroy
}

