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

VersPHP="7.3"
ContraRootMySQL=root
ContraBD="mpos"
UsuarioDaemon="poolravencoin"

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
echo "Creando el usuario para ejecutar el demonio..."
echo ""
  useradd -d /home/$UsuarioDaemon/ -s /bin/bash $UsuarioDaemon

echo ""
echo "Creando carpetas y archivos necesarios para ese usuario..."
echo ""
  mkdir -p /home/$UsuarioDaemon/ 2> /dev/null
  mkdir -p /home/$UsuarioDaemon/.raven/
  touch /home/$UsuarioDaemon/.raven/raven.conf
  echo "rpcuser=user1"      > /home/$UsuarioDaemon/.raven/raven.conf
  echo "rpcpassword=pass1" >> /home/$UsuarioDaemon/.raven/raven.conf
  echo "prune=550"         >> /home/$UsuarioDaemon/.raven/raven.conf
  echo "daemon=1"          >> /home/$UsuarioDaemon/.raven/raven.conf
  rm -rf /home/$UsuarioDaemon/Ravencoin/
  mv /root/SoftInst/Ravencoin/raven-$UltVersRaven/ /home/$UsuarioDaemon/Ravencoin/
  chown $UsuarioDaemon:$UsuarioDaemon /home/$UsuarioDaemon/ -R
  find /home/$UsuarioDaemon -type d -exec chmod 775 {} \;
  find /home/$UsuarioDaemon -type f -exec chmod 664 {} \;
  find /home/poolravencoin/Ravencoin/bin -type f -exec chmod +x {} \;
  su $UsuarioDaemon -c /home/$UsuarioDaemon/Ravencoin/bin/ravend
  #su $UsuarioDaemon -c "/home/$UsuarioDaemon/Ravencoin/bin/raven-cli getnewaddress" > /home/$UsuarioDaemon/Ravencoin/pooladdress.txt
  echo ""
  echo "La dirección de la cartera es:"
  cat /home/$UsuarioDaemon/Ravencoin/pooladdress.txt
  echo ""
  echo "Información de la cartera:"
  su $UsuarioDaemon -c "/home/$UsuarioDaemon/Ravencoin/bin/raven-cli getwalletinfo"
  echo ""
  echo "Conteo de bloques:"
  su $UsuarioDaemon -c "/home/$UsuarioDaemon/Ravencoin/bin/raven-cli getblockcount"
  echo ""
  su $UsuarioDaemon -c '/home/$UsuarioDaemon/Ravencoin/bin/raven-cli getaddressesbyaccount ""'
   
