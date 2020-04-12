#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------
#  Script de NiPeGun para instalar Steam en Debian 9
#-----------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Instalando Steam...${FinColor}"
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

