#!/bin/sh
#PDX-License-Identifier: MIT

# weaken sshd_config to allow Microsoft ssh tools to connect ...
sed -i -e 's/^Ciphers/#Ciphers/g' /etc/ssh/sshd_config
sed -i -e 's/^HostKeyAlgorithms/#HostKeyAlgorithms/g' /etc/ssh/sshd_config
sed -i -e 's/^KexAlgorithms/#KexAlgorithms/g' /etc/ssh/sshd_config
sed -i -e 's/^MACs/#MACs/g' /etc/ssh/sshd_config
sed -i -e 's/#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config