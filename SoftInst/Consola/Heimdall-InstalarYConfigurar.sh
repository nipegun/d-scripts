#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Heimdall Dashboard en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/Heimdall-InstalarYConfigurar.sh | bash
#
#----------------------------------------------------------------------------------------------------------------------------

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 7 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 8 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 9 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Instalación para Debian 11 todavía no preparada. Prueba instalarlo en otra versión de Debian"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Heimdall para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  UltArchivoZip=$(curl -s https://github.com/linuxserver/Heimdall/releases/ | grep href | grep .zip | cut -d '"' -f2 | head -n1)
  https://github.com/linuxserver/Heimdall/archive/refs/tags/2.2.2.zip
  mkdir -p /root/SoftInst/Heimdall/
  cd -p /root/SoftInst/Heimdall/
  ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  wget no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update > /dev/null
       apt-get -y install wget
       echo ""
     fi
  wget https://github.com$UltArchivoZip

fi
