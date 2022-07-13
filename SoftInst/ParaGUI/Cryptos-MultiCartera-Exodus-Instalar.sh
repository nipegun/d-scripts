#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar Exodus en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Coinomi-Instalar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-MultiCartera-Coinomi-Instalar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo "Este script está preparado para ejecutarse como root y no lo has ejecutado como root." >&2
    exit 1
  fi

ColorAzul="\033[0;34m"
ColorAzulClaro="\033[1;34m"
ColorVerde='\033[1;32m'
ColorRojo='\033[1;31m'
FinColor='\033[0m'

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${ColorRojo}  curl no está instalado. Iniciando su instalación...${FinColor}"
    echo ""
    sudo apt-get -y update > /dev/null
    sudo apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
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
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Exodus para Debian 7 (Wheezy)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Exodus para Debian 8 (Jessie)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Exodus para Debian 9 (Stretch)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Exodus para Debian 10 (Buster)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${ColorAzulClaro}  Iniciando el script de instalación de Exodus para Debian 11 (Bullseye)...${FinColor}"
  echo ""

  echo ""
  echo -e "${ColorRojo}  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${FinColor}"
  echo ""

fi
