#!/bin/sh
# SPDX-License-Identifier: MIT


set -u

#check if file exists

add_or_replace_in() {
	if grep "^$2" "$1" > /dev/null; then
		sed -i "" "s|^$2.*|$2$3|g" "$1"
	else
		echo "$2$3" >> "$1"
	fi
}
