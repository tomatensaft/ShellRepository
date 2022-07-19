#!/bin/sh
# SPDX-License-Identifier: MIT


#Print Header
printf "|---------------------------|\n"
printf "|                           |\n"
printf "|  Init Bhyve Net           |\n"
printf "|                           |\n"
printf "|                           |\n"
printf "|---------------------------|\n"

#Static Params - Adjust if needed / Init
tap=$(ifconfig -a | sed 's/[ \t:].*//;/^$/d' | grep tap)
bridge=$(ifconfig -a | sed 's/[ \t:].*//;/^$/d' | grep bridge)

#Main Functions
main_bhyve_net_config() {
    #Check Inputargs
    case $1 in
            --test)
                printf "Test Command for debugging $0\n"
                ;;

            --create)
                printf "Try create Bhyve Network\n"
                check_requirements
                select_nic
                check_nic
                create_bridge_tap
                create_firewall_rules
                ;;

            --start)
                printf "Try start Bhyve Network\n"
                check_requirements
                start_debian_guest
                ;;

            --delete)
                printf "Try delete Bhyve Newtork\n"
                delete_bridge
                ;;

            --info)
                    printf "Get Status of Bhyve Network\n"
                    clear
                    ;;
            *)
                    printf "Invalid option!\n\n"
                    usage
                    exit 1
                    ;;
    esac
}


#Create Brigde
create_bridge_tap() {
    $tap="$(ifconfig tap create)"
    $bridge="$(ifconfig bridge create)"
}


#Create Firewall Rules
create_firewall_rules()
{
    printf "Try to create bridge\n"
    sysctl net.link.tap.up_on_open=1
    ifconfig ${bridge} addm ${tap} addm ${nic} up
    sysctl net.link.bridge.pfil_member=0

    #Firewall Rules for Beckhoff device
    if uname -a | grep bhf; then
        printf "Beckhoff device foudn - create firewall rules\n"
        temp_firewall_rules="$(mktemp)"
        echo "pass in quick on ${bridge}" >> "${temp_firewall_rules}"
        echo "pass in quick proto tcp to port ${vnc_port}" >> "${temp_firewall_rules}"
        pfctl -a bhf/bhyve/debian-vm -f "${temp_firewall_rules}"
    else
        printf "No Beckhoff device - no firewall rules\n"
    fi
}


#Delete Bridge
delete_bridge() {
    printf "Try to delete bridge\n"
    ifconfig ${bridge} deletem ${tap} deletem ${nic}
    ifconfig ${bridge} down
    ifconfig ${bridge} destroy
    ifconfig ${tap} destroy
    if uname -a | grep bhf; then
        pfctl -a bhf/bhyve/debian-vm -f /dev/null
        #rm "${temp_firewall_rules}"
    fi
    
}


check_nic() {
    #Check if Nic Exist
    if ifconfig | grep $nic; then
        printf "NIC ${nic} found\n"
    else
        printf  "NIC ${nic} not found\n"
        exit 1
    fi
}

check_bridge(){
    #Check if Bridge exists
    if ifconfig | grep bridge; then
        printf "Bridge Allready Exists\n"
        exit 0
    fi
}

select_nic(){
    #Select NIC
    if [ ! -z $nic ]; then
        printf "Nic Parameter found\n"
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
}


check_requirements() {
    #Check Root
    if [ $(id -u) -ne 0 ]; then
        printf "Usage: run '$0' as root.\n"
        return 1
    fi
}

#Call main Function manualla - if not need uncomment - Lib Function
#main_bhyve_net_config "$@"; exit
