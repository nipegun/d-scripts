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
Hilos=$(dmidecode -t processor | grep ore | grep ount | cut -d ":" -f 2 | cut -d " " -f 2)

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
rm -rf ~/Cryptos/XMR/minero/
mkdir -p ~/Cryptos/XMR/
cd ~/Cryptos/XMR/
git clone https://github.com/xmrig/xmrig.git
cd xmrig

echo ""
echo "  Compilando..."
echo ""
## Crear la carpeta
   mkdir build
   cd build
## Instalar el softare para poder compilar
   apt-get -y install cmake
   apt-get -y install libhwloc-dev
   apt-get -y install libuv1-dev
   apt-get -y install libssl-dev
   apt-get -y install g++
   #apt-get -y install build-essential
## Compilar
   #cmake .. -DWITH_HWLOC=OFF
   cmake ..
   make -j $(nproc)

## Preparar la carpeta del minero
   mv ~/Cryptos/XMR/xmrig/build/ ~/Cryptos/XMR/minero/
   rm -rf ~/Cryptos/XMR/xmrig/

echo ""
echo "  Creando ID para el minero..."
echo ""

## A partir de la MAC WiFi
   ## Obtener MAC de la WiFi
      #DirMACwlan0=$(ip addr show wlan0 | grep link/ether | cut -d" " -f6 | sed 's/://g')
   ## Generar un identificador del minero a partir de la MAC de la WiFi...
      #IdMinero=$(echo -n $DirMACwlan0 | md5sum | cut -d" " -f1)

## A partir del ID del procesador
   ## Obtener ID del procesador
      IdProc=$(dmidecode -t 4 | grep ID | cut -d":" -f2 | sed 's/ //g')
   ## Generar un identificador del minero a partir del ID del procesador...
      IdMinero=$(echo -n $IdProc | md5sum | cut -d" " -f1)

echo ""
echo "  Ejecutando minero con identificador $IdMinero..."
echo ""

## Con TLS
   ~/Cryptos/XMR/minero/xmrig -o pool.minexmr.com:443 --threads=$Hilos --rig-id=$IdMinero -u $DirWallet --tls 

## Sin TLS
   #~/Cryptos/XMR/minero/xmrig -o pool.minexmr.com:4444 --threads=$Hilos --rig-id=$IdMinero -u $DirWallet

#/data/data/com.termux/files/home/xmrig/build/xmrig

