#!/bin/sh
# SPDX-License-Identifier: MIT



fetch ftp://ftp.freebsd.org/pub/`uname -s`/releases/`uname -m`/`uname -r | cut -d'-' -f1,2`/src.txz
tar -C / -xvzf src.txz
cat /etc/freebsd-update.conf