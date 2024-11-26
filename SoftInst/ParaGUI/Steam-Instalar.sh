#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Steam en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Steam-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 13 (x)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 12 (Bookworm)..."  
  echo ""

  apt-get -y update && apt-get -y install wget
  mkdir -p /root/SoftInst/Steam
  cd /root/Softinst/Steam
  wget https://cdn.fastly.steamstatic.com/client/installer/steam.deb
  apt -y install /root/SoftInst/Steam/Steam.deb
  dpkg --add-architecture i386
  apt-get -y update
  apt-get -y install libgl1-mesa-dri:i386
  apt-get -y install libgl1-mesa-glx:i386
  apt-get -y install libc6:i386

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 10 (Buster)..."  
  echo ""

  apt-get -y update
  apt-get -y install wget gdebi
  mkdir -p /root/paquetes/steam
  cd /root/paquetes/steam
  wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
  gdebi /root/paquetes/steam/steam.deb
  dpkg --add-architecture i386
  apt-get update
  apt-get -y install libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

