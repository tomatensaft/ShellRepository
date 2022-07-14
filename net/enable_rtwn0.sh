
#pciscan -ls - trwn

wlans_rtwn0="wlan0"    #wlan0 is now your network interface
ifconfig_wlan0=“WPA DHCP country DE”

wlans_rtwn0="wlan0"    #wlan0 is now your network interface
ifconfig_wlan0=“WPA inet 192.168.0.100 netmask 255.255.255.0 country DE”

wpa_supplicant.conf
network={
    ssid="myssid"    #for myssid specify the name of the network
    psk="mypsk"      #for mypsk enter password of network
}
