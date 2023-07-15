#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar RetroPie en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/RetroPie-Instalar.sh | bash
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de RetroPie para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de RetroPie para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de RetroPie para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de RetroPie para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "Instalando paquetes necesarios..." 
echo ""
  apt-get -y update
  apt-get upgrade -y
  apt-get -y install git dialog unzip xmlstarlet

  echo ""
  echo "Borrando instalación anterior, si es que existe..." 
echo ""
  unlink /root/.emulationstation
  unlink /root/.config/retroarch
  rm -rf /root/RetroPie
  rm -rf /opt/retropie

  mkdir /root/SoftInst/ 2> /dev/null
  cd /root/SoftInst/
  git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
  mv /root/SoftInst/RetroPie-Setup/ /root/SoftInst/RetroPie/
  echo ""
  echo "Se procederá con la instalación."
  echo ""
  echo 'En la primera ventana elige "Basic Install" y acepta la advertencia'
  echo ""
  echo "Luego, si quieres instalar el emulador de PSP ve al manejo de paquetes e instala:"
  echo "lr-ppsspp"
  echo ""

  # Packages
  sed -i -e 's|rootdir="/opt/retropie"|rootdir="/RetroPie/opt"|g'                           /root/SoftInst/RetroPie/retropie_packages.sh
  sed -i -e 's|datadir="$home/RetroPie"|datadir="/RetroPie"|g'                              /root/SoftInst/RetroPie/retropie_packages.sh
  sed -i -e 's|scriptdir="$(dirname "$0")"||g'                                              /root/SoftInst/RetroPie/retropie_packages.sh
  sed -i -e 's|scriptdir="$(cd "$scriptdir" && pwd)"|scriptdir="/root/SoftInst/RetroPie"|g' /root/SoftInst/RetroPie/retropie_packages.sh

  /root/SoftInst/RetroPie/retropie_setup.sh

  echo ""
  echo "Modificando archivos para adaptador a la nueva ubicación..." 
echo ""
  find /RetroPie/ -type f -exec sed -i -e "s|/opt/retropie|/RetroPie/opt|g" {} \;
  sed -i -e 's|/root/RetroPie/|/RetroPie/|g' /etc/emulationstation/es_systems.cfg
  chown nobody:nogroup /RetroPie/ -R

  echo ""
  echo "RetroPie se ha instalado."
  echo "Recuerda meter las roms en la carpeta /RetroPie/roms/"
  echo "antes de ejecutarlo por primera vez"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de RetroPie para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi
