#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar diferentes carteras de criptomonedas en Debian10
#-------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

DirWallet="451K8ZpJTWdLBKb5uCR1EWM5YfCUxdgxWFjYrvKSTaWpH1zdz22JDQBQeZCw7wZjRm3wqKTjnp9NKZpfyUzncXCJ24H4Xtr"

echo ""
echo -e "${ColorVerde}--------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de XMRig...${FinColor}"
echo -e "${ColorVerde}--------------------------------------------------${FinColor}"
echo ""

## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  git no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install git
     echo ""
   fi

echo ""
echo "  Descargando el repositorio de XMRig..."
echo ""
cd ~
git clone https://github.com/xmrig/xmrig.git
cd xmrig

echo ""
echo "  Compilando..."
echo ""
mkdir build
cd build
apt-get -y install cmake
#cmake .. -DWITH_HWLOC=OFF
cmake ..
make -j $(nproc)

echo ""
echo "  Generando un identificador de dispositivo con la MAC de la WiFi..."
echo ""
Dispositivo=$(ip addr show wlan0 | grep link/ether | cut -d " " -f6)
echo ""
echo "El identificador del dispositivo es:"
echo "$Dispositivo"
echo ""

echo ""
echo "  Ejecutando minero..."
echo ""
./xmrig -o pool.minexmr.com:4444 --rig-id=$Dispositivo -u 451K8ZpJTWdLBKb5uCR1EWM5YfCUxdgxWFjYrvKSTaWpH1zdz22JDQBQeZCw7wZjRm3wqKTjnp9NKZpfyUzncXCJ24H4Xtr
#/data/data/com.termux/files/home/xmrig/build/xmrig

