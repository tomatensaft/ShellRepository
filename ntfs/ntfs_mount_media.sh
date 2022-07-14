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

exit 0