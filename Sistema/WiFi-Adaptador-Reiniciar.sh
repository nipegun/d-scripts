#!/bin/bash

# ----------
# Script de NiPeGun para reiniciar el adaptador WiFi
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/WiFi-Adaptador-Reiniciar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/WiFi-Adaptador-Reiniciar.sh | bash
# ----------

vNombreDelDisp='wlan0'
vModKernelDelAdapt=$(lspci -kknn -d ::0280 | grep module | cut -d':' -f2 | sed 's- --g')

sudo ip link set $vNombreDelDisp down
sudo rfkill unblock all
sudo modprobe -r $vModKernelDelAdapt
sudo modprobe $vModKernelDelAdapt
sudo ip link set $vNombreDelDisp up

