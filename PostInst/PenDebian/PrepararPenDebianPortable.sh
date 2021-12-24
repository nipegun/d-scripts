#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------
#  Script de NiPeGun para preparar el Pendrive de Debian Portable
#
#  Ejecución remota:
#  curl -s | bash
#------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 7 (Wheezy) Portable..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 8 (Jessie) Portable..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 9 (Stretch) Portable..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 10 (Buster) Portable..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 11 (Bullseye) Portable..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  ## Instalación de paquetes
  apt-get -y update
  apt-get -y install gparted
  apt-get -y install wget
  apt-get -y install curl
  apt-get -y install nmap
  apt-get -y install mc

  ## Instalación de firmwares
  apt-get -y install firmware-linux-free
  apt-get -y install firmware-ath9k-htc
  apt-get -y install firmware-ath9k-htc-dbgsym
  apt-get -y install firmware-b43-installer
  apt-get -y install firmware-b43legacy-installer
  apt-get -y install atmel-firmware
  apt-get -y install bluez-firmware
  apt-get -y install firmware-amd-graphics
  apt-get -y install firmware-atheros
  apt-get -y install firmware-bnx2
  apt-get -y install firmware-bnx2x
  apt-get -y install firmware-brcm80211
  apt-get -y install firmware-cavium
  apt-get -y install firmware-intelwimax
  apt-get -y install firmware-ipw2x00
  apt-get -y install firmware-iwlwifi
  apt-get -y install firmware-linux
  apt-get -y install firmware-linux-nonfree
  apt-get -y install firmware-misc-nonfree
  apt-get -y install firmware-myricom
  apt-get -y install firmware-netronome
  apt-get -y install firmware-netxen
  apt-get -y install firmware-qcom-media
  apt-get -y install firmware-ralink
  apt-get -y install firmware-realtek
  apt-get -y install firmware-ti-connectivity
  apt-get -y install firmware-zd1211

fi
