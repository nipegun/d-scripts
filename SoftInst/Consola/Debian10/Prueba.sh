#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un pool de ravencoin (RVN) en Debian10
#---------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioDaemon="pool"
CarpetaSoft="Ravencoin"
DominioPool="localhost"

echo ""
echo ""
echo -e "${ColorVerde}-----------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación del pool de ravencoin...${FinColor}"
echo -e "${ColorVerde}-----------------------------------------------------------${FinColor}"
echo ""
echo ""

echo "Determinando la última versión de ravencoin..."
echo ""
## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
  echo ""
  echo "curl no está instalado. Iniciando su instalación..."
  echo ""
  apt-get -y update
  apt-get -y install curl
fi
UltVersRaven=$(curl --silent https://github.com/RavenProject/Ravencoin/releases/latest | cut -d '/' -f 8 | cut -d '"' -f 1 | cut -c2-)
echo ""
echo "La última versión de raven es la $UltVersRaven"
echo ""

echo ""
echo "Intentando descargar el archivo comprimido de la última versión..."
echo ""
mkdir -p /root/SoftInst/Ravencoin/ 2> /dev/null
rm -rf /root/SoftInst/Ravencoin/*
cd /root/SoftInst/Ravencoin/
## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
  echo ""
  echo "wget no está instalado. Iniciando su instalación..."
  echo ""
  apt-get -y update
  apt-get -y install wget
fi
echo ""
echo "  Pidiendo el archivo en formato zip..."
echo ""
wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.zip
echo ""
echo "  Pidiendo el archivo en formato tar.gz..."
echo ""
wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

echo ""
echo "Descomprimiendo el archivo..."
echo ""
  ## Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "zip no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install zip
  fi
  unzip /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
  mv /root/SoftInst/Ravencoin/linux/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz /root/SoftInst/Ravencoin/
  rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.zip
  rm -rf /root/SoftInst/Ravencoin/linux/
  rm -rf /root/SoftInst/Ravencoin/__MACOSX/
  ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "tar no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install tar
  fi
  tar -xf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz
  rm -rf /root/SoftInst/Ravencoin/raven-$UltVersRaven-x86_64-linux-gnu.tar.gz

echo ""
echo "Creando carpetas y archivos necesarios..."
echo ""
  mkdir ~/.raven/
  touch ~/.raven/raven.conf
  echo "rpcuser=user1"      > ~/.raven/raven.conf
  echo "rpcpassword=pass1" >> ~/.raven/raven.conf
  echo "prune=550"         >> ~/.raven/raven.conf
  echo "daemon=1"          >> ~/.raven/raven.conf
  rm -rf ~/$CarpetaSoft/
  mv ~/SoftInst/Ravencoin/raven-$UltVersRaven/ ~/$CarpetaSoft/
  find ~/$CarpetaSoft/bin -type f -exec chmod +x {} \;
  echo ""
  echo "Arrancando el daemon..."
  echo ""
  ~/$CarpetaSoft/bin/ravend
  sleep 3
  ~/$CarpetaSoft/bin/raven-cli getnewaddress > ~/pooladdress.txt
  echo ""
  echo "La dirección de la cartera es:"
  echo ""
  cat ~/pooladdress.txt
  DirCart=$(cat ~/pooladdress.txt)
  echo ""
  echo "Información de la cartera:"
  echo ""
  ~/$CarpetaSoft/bin/raven-cli getwalletinfo
  echo ""
  echo "Direcciones de recepción disponibles:"
  echo ""
  ~/$CarpetaSoft/bin/raven-cli getaddressesbyaccount ""
  echo ""
  echo "Conteo actual de bloques:"
  echo ""
  ~/$CarpetaSoft/bin/raven-cli getblockcount
  echo ""


echo ""
echo "Instalando la pool..."
echo ""
  ## Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "git no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install git
  fi
  cd ~/SoftInst/
  git clone https://github.com/notminerproduction/rvn-kawpow-pool.git
  mv ~/SoftInst/rvn-kawpow-pool/ ~/
  find ~/rvn-kawpow-pool/ -type f -iname "*.sh" -exec chmod +x {} \;
  sed -i -e 's|"stratumHost": "192.168.0.200",|"stratumHost": "'"$DominioPool"'",|g'                                            ~/rvn-kawpow-pool/config.json
  sed -i -e 's|"address": "RKopFydExeQXSZZiSTtg66sRAWvMzFReUj",|"address": "'"$DirCart"'",|g'                                   ~/rvn-kawpow-pool/pool_configs/ravencoin.json
  sed -i -e 's|"donateaddress": "RKopFydExeQXSZZiSTtg66sRAWvMzFReUj",|"donateaddress": "RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy",|g' ~/rvn-kawpow-pool/pool_configs/ravencoin.json
  sed -i -e 's|RL5SUNMHmjXtN1AzCRFQrFEhjnf7QQY7Tz|RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy|g'                                         ~/rvn-kawpow-pool/pool_configs/ravencoin.json
  sed -i -e 's|Ta26x9axaDQWaV2bt2z8Dk3R3dN7gHw9b6|RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy|g'                                         ~/rvn-kawpow-pool/pool_configs/ravencoin.json
  apt-get -y install npm
  
  find ~/rvn-kawpow-pool/install.sh -type f -exec sed -i -e "s|sudo ||g" {} \;
  
  ~/rvn-kawpow-pool/install.sh
  
  
