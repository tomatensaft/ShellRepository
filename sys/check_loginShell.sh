#!/bin/sh
#PDX-License-Identifier: MIT


printf "\n################################################\n"
printf "\n#             Check LoginShell                 #\n"
printf "\n################################################\n\n\n"

echo $(tty)

#Check User ant tty
if [ $(tty) = "/dev/ttyv0" ] && [ "$USER" = "Administrator" ]
then
         printf "\nExecute Autostart File..\n"
        ./autostart.sh
else
	printf "\nLogging in into an interactive shell - no autostart\n"	
fi