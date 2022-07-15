#!/bin/sh
# SPDX-License-Identifier: MIT


#Print Header
printf "|---------------------------|\n"
printf "|                           |\n"
printf "|  Init Bhyve Net           |\n"
printf "|  Parameter for NIC need   |\n"
printf "|                           |\n"
printf "|---------------------------|\n"

#Check Root
if [ $(id -u) -ne 0 ]; then
	printf "Usage: run '$0' as root.\n"
	return 1
fi

#Select NIC
if [ ! -z $nic ]; then
    printf "Nic Parameter found"
else
    #Check NIC Parameter
    if [ -z $1  ]; then
        printf "Parameter for NIC also Empty\n"
        return 1
    else
        nic=$1
        printf "Use NIC $nic\n" 
    fi
fi


#Params - Adjust if needed
tap="$(ifconfig tap create)"
bridge="$(ifconfig bridge create)"

#Check if Nic Exist
if ifconfig | grep $nic; then
    printf "NIC ${nic} found"
else
    printf  "NIC ${nic} not found"
    exit 1
fi

#Check if Bridge exists
if ifconfig | grep bridge; then
    printf "Bridge Allready Exists"
    return 0
fi

#Create Brige
create_bridge() {
    printf "Try to create bridge"
    sysctl net.link.tap.up_on_open=1
    ifconfig ${bridge} addm ${tap} addm ${nic} up
    sysctl net.link.bridge.pfil_member=0
    temp_firewall_rules="$(mktemp)"
    echo "pass in quick on ${bridge}" >> "${temp_firewall_rules}"
    echo "pass in quick proto tcp to port ${vnc_port}" >> "${temp_firewall_rules}"
    pfctl -a bhf/bhyve/debian-vm -f "${temp_firewall_rules}"
}


#Delete Bridge
delete_bridge() {
    printf "Try to delete bridge"
    ifconfig ${bridge} deletem ${tap} deletem ${nic}
    ifconfig ${bridge} down
    ifconfig ${bridge} destroy
    ifconfig ${tap} destroy
    pfctl -a bhf/bhyve/debian-vm -f /dev/null
    #rm "${temp_firewall_rules}"
}
