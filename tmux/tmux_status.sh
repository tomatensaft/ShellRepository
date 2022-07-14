#!/bin/sh
# SPDX-License-Identifier: MIT

#Determine systeminfos for tmux status

usage() {
	printf "Usage: \n"
	printf "\t${0} [cpu|mem|net|tc]\n\n"
	exit 1
}

case ${1-} in
	cpu)
		vmstat | awk 'NR==3 {print "CPU User: "$(NF-2)"% System: "$(NF-1)"% Idle: "$(NF) "%"}'
		;;
	mem)
		vmstat | awk 'NR==3 {print "Free Hdd: " $(4)/1000000 " Free RAM: " $(5)/1000000}'
		;;
	net)
		ifout=""
		for ifcfg in $(ifconfig -lu)
		do
   			ifout="${ifout} $(ifconfig $ifcfg | grep -v inet6 | awk -v ifcfg=$ifcfg '/inet6?/{print ifcfg " : " $2}')"
		done
		printf "${ifout}\n"
		;;
	tc)
		TcSysExe.exe --mode | cut -f 2
		;;

	*)
		printf "Invalid parameter '${1-"<none>"}'!\n\n"
		usage
		;;
esac