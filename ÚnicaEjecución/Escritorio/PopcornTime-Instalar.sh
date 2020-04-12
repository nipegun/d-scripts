#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------
#  Script de NiPeGun para instalar PopcornTime en Debian 9
#-----------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Instalando PopCornTime...${FinColor}"
echo ""
apt-get update
apt-get -y install wget
ArchivoADescargar=$(wget --no-check-certificate -qO- https://get.popcorntime.sh/repo/build/ | grep Linux-64 | head -n 1 | cut -d\" -f2)
mkdir /root/paquetes/
cd /root/paquetes/
wget --no-check-certificate https://get.popcorntime.sh/repo/build/$ArchivoADescargar
mkdir /opt/popcorn-time
tar -xvf $ArchivoADescargar -C /opt/popcorn-time
ln -sf /opt/popcorn-time/Popcorn-Time /usr/bin/popcorn-time
echo "[Desktop Entry]" > /usr/share/applications/popcorntime.desktop
echo "Version = 1.0" >> /usr/share/applications/popcorntime.desktop
echo "Type = Application" >> /usr/share/applications/popcorntime.desktop
echo "Terminal = false" >> /usr/share/applications/popcorntime.desktop
echo "Name = Popcorn Time" >> /usr/share/applications/popcorntime.desktop
echo "Exec = /usr/bin/popcorn-time" >> /usr/share/applications/popcorntime.desktop
echo "Icon = /opt/popcorn-time/popcorntime.png" >> /usr/share/applications/popcorntime.desktop
echo "Categories = Application;" >> /usr/share/applications/popcorntime.desktop
wget -q -O /opt/popcorn-time/popcorntime.png https://upload.wikimedia.org/wikipedia/commons/6/6c/Popcorn_Time_logo.png

