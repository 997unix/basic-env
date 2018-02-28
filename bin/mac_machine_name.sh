#!/bin/bash

if [ -z "$1" ]; then 
	echo "usage: $0 machinename"
	exit
fi

if [ $EUID != 0 ]; then
	echo "must run with sudo"
	exit
fi


NAME=$1

echo diskutil rename / "${NAME}"
diskutil rename / "${NAME}"

echo 'echo HOSTNAME="${NAME}" >> /etc/hostconfig'
echo HOSTNAME="${NAME}" >> /etc/hostconfig
echo 
echo scutil --set HostName ${NAME}
scutil --set HostName ${NAME}
echo scutil --set ComputerName ${NAME}
scutil --set ComputerName ${NAME}
echo scutil --set LocalHostName ${NAME}
scutil --set LocalHostName ${NAME}
echo
echo "rename complete"               
echo
