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

echo ""
echo "-------------------------------------------------"
echo "Iniciando el script de instalación de RetroPie..."
echo "-------------------------------------------------"
echo ""

echo ""
echo "Instalando paquetes necesarios..."
echo ""
apt-get update -y
apt-get upgrade -y
apt-get install -y git dialog unzip xmlstarlet

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

## Packages
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

echo ""
echo "RetroPie se ha instalado."
echo "Recuerda meter las roms en la carpeta /RetroPie/roms/"
echo "antes de ejecutarlo por primera vez"
echo ""

