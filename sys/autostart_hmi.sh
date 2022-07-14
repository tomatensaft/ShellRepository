#!/bin/sh
# SPDX-License-Identifier: MIT


printf "\n################################################\n"
printf "\n#             StartupOptions                   #\n"
printf "\n################################################\n\n\n"
printf "(h)mi Webclient (Standard)\n\n"
printf "(s)ervice mode - KDE\n\n"
printf "(c)console\n\n\n"

read -t 8 -p "Choose Startoption and hit ENTER [h,s,c]: " startOption
: "${startOption:=h}"

case $startOption in
        h)
                printf "Starting Standalone Browseri Chromium ..."
			echo "exec /usr/local/bin/chrome" > ~/.xinitrc
			startx
                ;;
        s)
                printf "Starting Servicemode - KDE ..."
			echo "exec ck-launch-session startplasma-x11" > ~/.xinitrc
			startx
                ;;
        c)
                printf "Starting Console ..."
				clear
                ;;
        *)
                printf "Invalid option!\n\n"
                ;;
esac
