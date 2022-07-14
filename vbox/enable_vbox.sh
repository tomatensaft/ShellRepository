
#!/bin/sh
# SPDX-License-Identifier: MIT

#Dont forget to switch correct VGA Card in the VBox Settings

env ASSUME_ALWAYS_YES=YES pkg install virtualbox-ose-additions

add_or_replace_in /etc/rc.conf 'vboxguest_enable=' '"YES"'
add_or_replace_in /etc/rc.conf 'vboxservice_enable=' '"YES"'

# and start ...
service vboxguest start
service vboxservice start