#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar RetroPie en Debian
#-------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

apt-get update -y
apt-get upgrade -y
apt-get install -y git dialog unzip xmlstarlet
mkdir /root/SoftInst/
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

#sed -i -e 's|scriptdir="$(dirname "$0")"||g'                                              /root/SoftInst/RetroPie/retropie_setup.sh
#sed -i -e 's|scriptdir="$(cd "$scriptdir" && pwd)"|scriptdir="/root/SoftInst/RetroPie"|g' /root/SoftInst/RetroPie/retropie_setup.sh

## Packages
sed -i -e 's|rootdir="/opt/retropie"|rootdir="/RetroPie/opt"|g'                           /root/SoftInst/RetroPie/retropie_packages.sh
sed -i -e 's|datadir="$home/RetroPie"|datadir="/RetroPie"|g'                              /root/SoftInst/RetroPie/retropie_packages.sh
sed -i -e 's|scriptdir="$(dirname "$0")"||g'                                              /root/SoftInst/RetroPie/retropie_packages.sh
sed -i -e 's|scriptdir="$(cd "$scriptdir" && pwd)"|scriptdir="/root/SoftInst/RetroPie"|g' /root/SoftInst/RetroPie/retropie_packages.sh

mkdir /RetroPie/

/root/SoftInst/RetroPie/retropie_setup.sh
mv /root/RetroPie/ /RetroPie/
sed -i -e 's|/root/RetroPie/|/RetroPie/|g' /etc/emulationstation/es_systems.cfg

