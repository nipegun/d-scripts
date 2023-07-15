#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

---
#  Script de NiPeGun para instalar y configurar la cadena de bloques de Litecoin (LTC)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-LTC-InstalarYConfigurar.sh | bash
---

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

UsuarioNoRoot="nipegun"

echo ""
echo -e "${cColorVerde}------------------------------------------------------------------------${cFinColor}"
echo -e "${cColorVerde}  Iniciando el script de instalación de la cadena de bloques de LTC...${cFinColor}"
echo -e "${cColorVerde}------------------------------------------------------------------------${cFinColor}"
echo ""

echo ""
echo "  Determinando la última versión de litecoin core..."
echo ""
# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  curl no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi
UltVersLTC=$(curl -s https://litecoin.org | sed 's-//-\n-g' | sed 's-" -\n-g' | grep linux | grep 64 | grep -v ">" | head -n1 | cut -d "-" -f2 | cut -d "/" -f1)
echo ""
echo "  La última versión de litecoin es la $UltVersLTC"
echo ""

echo ""
echo "  Intentando descargar el archivo comprimido de la última versión..."
echo ""
mkdir -p /root/SoftInst/Cryptos/LTC/ 2> /dev/null
rm -rf /root/SoftInst/Cryptos/LTC/*
cd /root/SoftInst/Cryptos/LTC/
## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  wget no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install wget
     echo ""
   fi
echo ""
echo "  Pidiendo el archivo en formato zip..."
echo ""
wget https://download.litecoin.org/litecoin-$UltVersLTC/linux/litecoin-$UltVersLTC-x86_64-linux-gnu.zip
echo ""
echo "  Pidiendo el archivo en formato tar.gz..."
echo ""
wget https://download.litecoin.org/litecoin-$UltVersLTC/linux/litecoin-$UltVersLTC-x86_64-linux-gnu.tar.gz

echo ""
echo "  Descomprimiendo el archivo..."
echo ""
# Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  zip no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install zip
    echo ""
  fi
unzip /root/SoftInst/Cryptos/LTC/litecoin-$UltVersLTC-x86_64-linux-gnu.zip
mv /root/SoftInst/Cryptos/LTC/linux/litecoin-$UltVersLTC-x86_64-linux-gnu.tar.gz /root/SoftInst/Cryptos/LTC/
rm -rf /root/SoftInst/Cryptos/LTC/litecoin-$UltVersLTC-x86_64-linux-gnu.zip
rm -rf /root/SoftInst/Cryptos/LTC/linux/
rm -rf /root/SoftInst/Cryptos/LTC/__MACOSX/
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  tar no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install tar
    echo ""
  fi
tar -xf /root/SoftInst/Cryptos/LTC/litecoin-$UltVersLTC-x86_64-linux-gnu.tar.gz
rm -rf /root/SoftInst/Cryptos/LTC/litecoin-$UltVersLTC-x86_64-linux-gnu.tar.gz

echo ""
echo "  Creando carpetas y archivos necesarios para ese usuario..."
echo ""
mkdir -p /home/$UsuarioNoRoot/Cryptos/LTC/ 2> /dev/null
mkdir -p /home/$UsuarioNoRoot/.litecoin/
touch /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "rpcuser=ltcrpc"           > /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "rpcpassword=ltcrpcpass"  >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "rpcallowip=127.0.0.1"    >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "#Default RPC port 8766"  >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "rpcport=20401"           >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "server=1"                >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "listen=1"                >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "prune=550"               >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "daemon=1"                >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
echo "gen=0"                   >> /home/$UsuarioNoRoot/.litecoin/litecoin.conf
rm -rf /home/$UsuarioNoRoot/Cryptos/LTC/
mv /root/SoftInst/Cryptos/LTC/litecoin-$UltVersLTC/ /home/$UsuarioNoRoot/Cryptos/LTC/
chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/LTC/ -R
find /home/$UsuarioNoRoot/Cryptos/LTC/ -type d -exec chmod 775 {} \;
find /home/$UsuarioNoRoot/Cryptos/LTC/ -type f -exec chmod 664 {} \;
find /home/$UsuarioNoRoot/Cryptos/LTC/bin -type f -exec chmod +x {} \;

#echo ""
#echo "  Arrancando litecoind..."
#echo ""
#su $UsuarioNoRoot -c /home/$UsuarioNoRoot/Cryptos/LTC/bin/litecoind
#sleep 5
#su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/LTC/bin/litecoin-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-ltc.txt
#chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-ltc.txt
#echo ""
#echo "  La dirección para recibir litecoin es:"
#echo ""
#cat /home/$UsuarioNoRoot/pooladdress-ltc.txt
#DirCartLTC=$(cat /home/$UsuarioNoRoot/pooladdress-ltc.txt)
#echo ""

## Autoejecución de Litecoin al iniciar el sistema
   #echo ""
   #echo "  Agregando litecoind a los ComandosPostArranque..."
   #echo ""
   #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-iniciar.sh
   #echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/ltc-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

## Icono de lanzamiento en el menú gráfico
   echo ""
   echo "  Agregando la aplicación gráfica al menú..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
   echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   echo "Name=ltc GUI"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/ltc-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   echo "Categories=Cryptos"                                              >> /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   #echo "Icon="                                                          >> /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop
   gio set /home/$UsuarioNoRoot/.local/share/applications/ltc.desktop "metadata::trusted" yes

## Autoejecución gráfica de Litecoin
   echo ""
   echo "  Creando el archivo de autoejecución de litecoin-qt para escritorio..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
   echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.config/autostart/ltc.desktop
   echo "Name=ltc GUI"                                                    >> /home/$UsuarioNoRoot/.config/autostart/ltc.desktop
   echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.config/autostart/ltc.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/ltc-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.config/autostart/ltc.desktop
   echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.config/autostart/ltc.desktop
   echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.config/autostart/ltc.desktop
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.config/autostart/ltc.desktop
   gio set /home/$UsuarioNoRoot/.config/autostart/ltc.desktop "metadata::trusted" yes

## Reparación de permisos
   chmod +x /home/$UsuarioNoRoot/Cryptos/LTC/bin/*
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/LTC/ -R

## Instalar los c-scripts
   echo ""
   echo "  Instalando los c-scripts..."
   echo ""
   su $UsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
   find /home/$UsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

## Parar el daemon
   #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-parar.sh
   #su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/ltc-daemon-parar.sh"

