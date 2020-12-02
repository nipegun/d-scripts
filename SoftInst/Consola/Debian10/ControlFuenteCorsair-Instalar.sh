#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar LiquidControl en Debian10
#--------------------------------------------------------------------------

apt-get -y update && apt-get -y install git build-essential pkg-config libusb-1.0-0-dev

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Preparando la instalación de LiquidControl...${FinColor}"
echo ""
apt-get -y update
apt-get -y install python3
apt-get -y install libusb-1.0-0
apt-get -y python3-pkg-resources
apt-get -y python3-docopt
apt-get -y python3-usb
apt-get -y python3-hid
apt-get -y python3-smbus
apt-get -y python3-setuptools
apt-get -y python3-pip
apt-get -y python3-pytest
mkdir /root/CodFuente
cd /root/CodFuente
git clone https://github.com/jonasmalacofilho/liquidctl
cd liquidctl
python3 setup.py install
echo ""
echo "Instalación terminada. Para ver la ayuda ejecuta..."
echo ""
echo "liquidctl --help"
echo ""
echo "Mostrando dispositivos compatibles..."
liquidctl list --verbose
echo "Iniciando comunicación con los dispositivos..."
liquidctl initialize
echo ""
echo "Mostrando estado del dispositivo...
echo ""
liquidctl status

