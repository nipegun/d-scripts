#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar DDClient en Debian
#--------------------------------------------------------------------

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
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TorGhost para Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Script para Debian 7 todavía no preparado. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TorGhost para Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Script para Debian 8 todavía no preparado. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TorGhost para Debian 9 (Stretch)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Script para Debian 9 todavía no preparado. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TorGhost para Debian 10 (Buster)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Script para Debian 10 todavía no preparado. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de TorGhost para Debian 11 (Bullseye)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  git no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install git
     echo ""
   fi
  mkdir -p /root/SoftInst/TorGhost/
  cd /root/SoftInst/TorGhost/
  git clone https://github.com/SusmithKrishnan/torghost.git
  mv torghost GitHub
  cd GitHub
  chmod +x build.sh
  apt-get -y install cython3
  find /root/SoftInst/TorGhost/GitHub/ -type f -exec sed -i 's/sudo//g' {} +
  #UltVersDevel=$(apt-cache search python3. | grep 3.9 | grep eader | cut -d ' ' -f1 | grep -v lib)
  #apt-get -y install python-dev python3-dev
  #apt-get -y install $UltVersDevel
  ./build.sh

fi
