#!/bin/bash

vNombreDelDisp='wlan0'
vModKernelDelAdapt=$(lspci -kknn -d ::0280 | grep module | cut -d':' -f2 | sed 's- --g')

sudo ip link set $vNombreDelDisp down
sudo rfkill unblock all
sudo modprobe -r $vModKernelDelAdapt
sudo modprobe $vModKernelDelAdapt
sudo ip link set $vNombreDelDisp up

