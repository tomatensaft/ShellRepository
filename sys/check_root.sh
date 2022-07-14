#!/bin/sh
#PDX-License-Identifier: MIT

if [ $(id -u) -ne 0 ]; then
	throw "Usage: run '$0' as root.\n"
fi

#return Paraneter