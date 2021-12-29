#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------
#  Script de NiPeGun para instalar el controlador de las gráficas AMD
#----------------------------------------------------------------------

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
  echo "--------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 7 (Wheezy)..."
  echo "--------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 8 (Jessie)..."
  echo "--------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------------------"
  echo ""

  # Drivers
  apt-get -y update
  apt-get -y install firmware-amd-graphics
  apt-get -y install firmware-linux
  apt-get -y install firmware-linux-free
  apt-get -y install firmware-linux-nonfree
  apt-get -y install libdrm-amdgpu1

  # Vulkan
  apt-get -y install mesa-vulkan-drivers
  apt-get -y install libvulkan1
  apt-get -y install vulkan-tools
  apt-get -y install vulkan-utils
  apt-get -y install vulkan-validationlayers

  # OpenCL
  apt-get -y install mesa-opencl-icd

  # Drivers
  #apt-get -y update
  #apt-get -y remove firmware-amd-graphics
  #apt-get -y remove firmware-linux
  #apt-get -y remove firmware-linux-free
  #apt-get -y remove firmware-linux-nonfree
  #apt-get -y remove libdrm-amdgpu1

  # Vulkan
  #apt-get -y remove mesa-vulkan-drivers
  #apt-get -y remove libvulkan1
  #apt-get -y remove vulkan-tools
  #apt-get -y remove vulkan-utils
  #apt-get -y remove vulkan-validationlayers

  # OpenCL
  #apt-get -y remove mesa-opencl-icd

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 11 (Bullseye)..."
  echo "-----------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

