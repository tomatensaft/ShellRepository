#!/bin/sh
# SPDX-License-Identifier: MIT

for ifcfg in $(ifconfig -lu)
do
    mac=$(ifconfig $ifcfg | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
    ifconfig $ifcfg | grep -v inet6 | awk -v ifcfg=$ifcfg,$mac '/inet6?/{print ifcfg mac "," $2}' | grep -v lo
done
