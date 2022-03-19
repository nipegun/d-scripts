#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar los sensores de hardware
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Sensores-InstalarYDetectar.sh | bash
#------------------------------------------------------------------------------------------------------------------------

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
  echo "------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración de sensores de hardware en Debian 7 (Wheezy)..."
  echo "------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración de sensores de hardware en Debian 8 (Jessie)..."
  echo "------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración de sensores de hardware en Debian 9 (Stretch)..."
  echo "-------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración de sensores de hardware en Debian 10 (Buster)..."
  echo "-------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${ColorVerde}  Instalando el paquete lm-sensors...${FinColor}"
  echo ""
  apt-get -y update
  apt-get -y install lm-sensors

  echo ""
  echo -e "${ColorVerde}  Instalando el paquete hddtemp...${FinColor}"
  echo ""
  apt-get -y update
  apt-get -y install hddtemp

  echo ""
  echo -e "${ColorVerde}  Detectando los sensores...${FinColor}"
  echo ""
  /usr/bin/yes YES | /usr/sbin/sensors-detect

  echo ""
  echo -e "${ColorVerde}  Activando el módulo del kernel...${FinColor}"
  echo ""
  /etc/init.d/kmod start

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación y configuración de sensores de hardware en Debian 11 (Bullseye)..."
  echo "---------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${ColorVerde}  Instalando el paquete lm-sensors...${FinColor}"
  echo ""
  apt-get -y update
  apt-get -y install lm-sensors

  echo ""
  echo -e "${ColorVerde}  Instalando el paquete hddtemp...${FinColor}"
  echo ""
  apt-get -y update
  apt-get -y install hddtemp

  echo ""
  echo -e "${ColorVerde}  Detectando los sensores...${FinColor}"
  echo ""
  /usr/bin/yes YES | /usr/sbin/sensors-detect

  echo ""
  echo -e "${ColorVerde}  Activando el módulo del kernel...${FinColor}"
  echo ""
  /etc/init.d/kmod start

fi

