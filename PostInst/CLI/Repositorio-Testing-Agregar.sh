#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para agregar el repositorio testing a Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Repositorio-Testing-Agregar.sh | bash
#
#  Para instalar un paquete desde backports:
#  apt-get -y install -t testing NombreDelPaquete
# ----------

#vRepoActual=$(lsb_release -a | grep odename | cut -d':' -f2 | sed -e 's/^[ \t]*//')
vRepoActual=$(cat /etc/os-release | grep CODENAME | cut -d'=' -f2)

vColorRojo='\033[1;31m'
vColorVerde='\033[1;32m'
vFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar el repositorio testing a Debian 7 (Wheezy)..."
  echo "------------------------------------------------------------------------------------"
  echo ""

  echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
  apt-get update

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar el repositorio testing a Debian 8 (Jessie)..."
  echo "------------------------------------------------------------------------------------"
  echo ""

  echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
  apt-get update

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar el repositorio testing a Debian 9 (Stretch)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
  apt-get update

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar el repositorio testing a Debian 10 (Buster)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
  apt-get update

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script para agregar el repositorio testing a Debian 11 (Bullseye)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  echo "deb http://deb.debian.org/debian testing main contrib non-free" > /etc/apt/sources.list.d/testing.list
  apt-get update

fi
