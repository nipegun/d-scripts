#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------
#  Script de NiPeGun para bajar, configurar, instalar y ejecutar NBMiner en Debian
#-----------------------------------------------------------------------------------

echo ""
echo "  Consultando la última versión disponible de NBMiner..."
echo ""
UltVers=$(curl --silent https://github.com/NebuTech/NBMiner/releases/latest | cut -d '"' -f2 | cut -d "/" -f 8 | sed 's/v//g')

echo ""
echo "  La última versión de NBMiner es la $UltVers."
echo ""

echo ""
echo "  Descargando el archivo comprimido con la versión $UltVers de NBMiner... "
echo ""
rm -rf ~/Cryptos/Mineros/GPU/NBMiner/
mkdir -p ~/Cryptos/Mineros/GPU/
cd ~/Cryptos/Mineros/GPU/
## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  wget no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install wget
     echo ""
   fi
wget https://github.com/NebuTech/NBMiner/releases/download/v"$UltVers"/NBMiner_"$UltVers"_Linux.tgz

echo ""
echo "  Descomprimiendo el archivo... "
echo ""
## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  tar no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install tar
     echo ""
   fi
tar -xf ~/Cryptos/Mineros/GPU/NBMiner_$UltVers_Linux.tgz
mv ~/Cryptos/Mineros/GPU/NBMiner_Linux/ ~/Cryptos/Mineros/GPU/NBMiner/
rm -rf ~/Cryptos/Mineros/GPU/NBMiner_$UltVers_Linux.tgz
