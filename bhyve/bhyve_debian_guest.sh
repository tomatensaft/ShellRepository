#!/bin/sh
# SPDX-License-Identifier: MIT


#Install Debian Bhyve Guest

#Print Header
printf "|---------------------------|\n"
printf "|                           |\n"
printf "|  Exmaple Bhyve Debian     |\n"
printf "|                           |\n"
printf "|                           |\n"
printf "|---------------------------|\n"

#Static Params - Adjust if needed / Init
iso_file="$(pwd)/debian-installer.iso"
debian_file="debian-11.4.0-amd64-netinst.iso"
vm_disk="zroot/debian-vm_disk0"
vnc_port="5900"
nic="wlan0" 

#Include extenal scripts
. bhyve_net_config.sh

#Main Functions
main_bhyve_debian_guest() {
    #Check Inputargs
    case $1 in
            --test)
                printf "Test Command for debugging $0\n"
                main_bhyve_net_config --test
                ;;

            --create)
                printf "Try create Bhyve Debian guest\n"
                check_requirements
                main_bhyve_net_config --create
                load_iso
                create_zfs_disk 
                install_debian_guest
                ;;

            --start)
                printf "Try start Bhyve Debian guest\n"
                check_requirements
                start_debian_guest
                ;;


            --delete)
                printf "Try delete Bhyve Debian guest\n"
                main_bhyve_net_config --delete
                delete_debian_guest
                ;;

            --info)
                printf "Get Status of Bhyve Debian Guest\n"
                clear
                ;;
            *)
                printf "Invalid option!\n\n"
                usage      
                ;;
    esac
}


#Get IsoFiles
load_iso() {
    printf "Fetch Debian Iso File ${debian_file}..\n"
    if ls | grep installer.iso; then #Any Installer Iso
        printf "File found allready ${debian_file}..\n"
    else
        fetch -o "${iso_file}" "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/${debian_file}"
    fi
}

#Check zroot disk exists
create_zfs_disk() {
    if zfs list | grep ${vm_disk}; then
        printf "zfs disk found\n"
    else    
        printf "zfs create disk ${vm_disk}"    
        zfs create -V 10G -o volmode=dev ${vm_disk}
    fi
}

#Start Bhyve Debian Guest
install_debian_guest() 
{
    #2 Cores / 2 GigRAM / VirtIO / Uefi
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

#Start Bhyve Debian Guest
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

#Delete Bhyve Debian Guest
delete_debian_guest() 
{
    bhyvectl --vm=debian-vm --destroy
}


#Check requirements
check_requirements()
{
    #Check Root
    if [ $(id -u) -ne 0 ]; then
        printf "Usage: run '$0' as root.\n"
        exit 1
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
    fi
}


#Usage
usage() {
    printf "$0 Usage: --"
    printf "[test,create,start,stop,info,delete]\n\n"
    exit 1
}


#Call main Function manualla - if not need uncomment
main_bhyve_debian_guest "$@"; exit