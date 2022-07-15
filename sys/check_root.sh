#!/bin/sh
#PDX-License-Identifier: MIT

#Check Root Access

if [ $(id -u) -ne 0 ]; then
	printf "Usage: run '$0' as root.\n"
	#Failed
	return 1
fi

#Succeeded
return 0