#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el último kernel disponible en backports
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Kernel-InstalarUltimoDeBackports.sh | bash
# ----------

RepoActual="bullseye"

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

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
  echo "----------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del último kernel disponible en backports para Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del último kernel disponible en backports para Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del último kernel disponible en backports para Debian 9 (Stretch)..."
  echo "-----------------------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del último kernel disponible en backports para Debian 10 (Buster)..."
  echo "-----------------------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del último kernel disponible en backports para Debian 11 (Bullseye)..."
  echo "-------------------------------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

fi

