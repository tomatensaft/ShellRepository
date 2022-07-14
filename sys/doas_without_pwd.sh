#!/bin/sh
#PDX-License-Identifier: MIT

##Inert Parmateer


# allow Administrator to use doas without password
sed -i -e 's/^permit Administrator/permit nopass Administrator/' /usr/local/etc/doas.conf