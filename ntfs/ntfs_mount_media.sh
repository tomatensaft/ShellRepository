#!/bin/sh

#Mount NTFS File System

#check fusefs package
pkginfo=$(pkg info | grep fusefs)

#check fusefs pkf search if not found in info
pkgsearch=$(pkg search fusefs) #Split with tr for real name

#install packae
pkginstall=$(pkg install fusefs-ntfs)

#Check fusefs module
kldresult=$(kldstat | grep pty)

echo $kldresult

if [ -n "${kldresult}" ]; then
    echo Found
else
    echo NotFound
fi 

##Test
pw groupmod operator -m Administrator
kldload fuse
sysctl vfs.usermount=1

# make the above changes permanent
add_or_replace_in /boot/loader.conf 'fuse_load=' '"YES"'
add_or_replace_in /etc/sysctl.conf 'vfs.usermount=' '"1"'

exit 0