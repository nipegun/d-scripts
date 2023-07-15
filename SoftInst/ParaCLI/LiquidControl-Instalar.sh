#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar LiquidControl en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/LiquidControl-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de LiquidControl para Debian 7 (Wheezy)..."
  echo "---------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de LiquidControl para Debian 8 (Jessie)..."
  echo "---------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de LiquidControl para Debian 9 (Stretch)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de LiquidControl para Debian 10 (Buster)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  apt-get -y update
  apt-get -y install python3
  apt-get -y install libusb-1.0-0
  apt-get -y install python3-pkg-resources
  apt-get -y install python3-docopt
  apt-get -y install python3-usb
  apt-get -y install python3-hid
  apt-get -y install python3-smbus
  apt-get -y install python3-setuptools
  apt-get -y install python3-pip
  apt-get -y install python3-pytest
  rm -rf /root/SoftInst/liquidctl/ 2> /dev/null
  mkdir -p /root/SoftInst/ 2> /dev/null
  cd /root/SoftInst/
  git clone https://github.com/jonasmalacofilho/liquidctl
  cd liquidctl
  python3 setup.py install
  echo ""
  echo "  Instalación terminada. Para ver la ayuda ejecuta..."
  echo ""
  echo "  liquidctl --help"
  echo ""
  echo "  Mostrando dispositivos compatibles..."
  echo ""
  liquidctl list --verbose
  echo "  Iniciando comunicación con los dispositivos..."
  liquidctl initialize
  echo ""
  echo "  Mostrando estado del dispositivo..."
  echo ""
  liquidctl status

elif [ $cVerSO == "11" ]; then

  echo ""

  echo "  Iniciando el script de instalación de LiquidControl para Debian 11 (Bullseye)..."

  echo ""

  apt-get -y update
  apt-get -y install python3
  apt-get -y install libusb-1.0-0
  apt-get -y install python3-pkg-resources
  apt-get -y install python3-docopt
  apt-get -y install python3-usb
  apt-get -y install python3-hid
  apt-get -y install python3-smbus
  apt-get -y install python3-setuptools
  apt-get -y install python3-pip
  apt-get -y install python3-pytest
  rm -rf /root/SoftInst/liquidctl/ 2> /dev/null
  mkdir -p /root/SoftInst/ 2> /dev/null
  cd /root/SoftInst/
  git clone https://github.com/jonasmalacofilho/liquidctl
  cd liquidctl
  python3 setup.py install
  echo ""
  echo "  Instalación terminada. Para ver la ayuda ejecuta..."
  echo ""
  echo "  liquidctl --help"
  echo ""
  echo "  Mostrando dispositivos compatibles..."
  echo ""
  liquidctl list --verbose
  echo "  Iniciando comunicación con los dispositivos..."
  liquidctl initialize
  echo ""
  echo "  Mostrando estado del dispositivo..."
  echo ""
  liquidctl status

fi
