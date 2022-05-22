#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar la cadena de bloques de Argentum (ARG)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-ARG-Nodo-InstalarYConfigurar.sh | bash
#--------------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot="nipegun"

echo ""
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de la cadena de bloques de ARG...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo ""

echo ""
echo "  Determinando la última versión de argentum core..."
echo ""
## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  curl no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install curl
     echo ""
   fi
UltVersARG=$(curl -s https://argentum.org | sed 's-//-\n-g' | sed 's-" -\n-g' | grep linux | grep 64 | grep -v ">" | head -n1 | cut -d "-" -f2 | cut -d "/" -f1)
echo ""
echo "  La última versión de argentum es la $UltVersARG"
echo ""

echo ""
echo "  Intentando descargar el archivo comprimido de la última versión..."
echo ""
mkdir -p /root/SoftInst/Cryptos/ARG/ 2> /dev/null
rm -rf /root/SoftInst/Cryptos/ARG/*
cd /root/SoftInst/Cryptos/ARG/
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
wget https://download.argentum.org/argentum-$UltVersARG/linux/argentum-$UltVersARG-x86_64-linux-gnu.zip
echo ""
echo "  Pidiendo el archivo en formato tar.gz..."
echo ""
wget https://download.argentum.org/argentum-$UltVersARG/linux/argentum-$UltVersARG-x86_64-linux-gnu.tar.gz
echo ""
echo "  Descomprimiendo el archivo..."
echo ""
## Comprobar si el paquete zip está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s zip 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  zip no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install zip
     echo ""
   fi
unzip /root/SoftInst/Cryptos/ARG/argentum-$UltVersARG-x86_64-linux-gnu.zip
mv /root/SoftInst/Cryptos/ARG/linux/argentum-$UltVersARG-x86_64-linux-gnu.tar.gz /root/SoftInst/Cryptos/ARG/
rm -rf /root/SoftInst/Cryptos/ARG/argentum-$UltVersARG-x86_64-linux-gnu.zip
rm -rf /root/SoftInst/Cryptos/ARG/linux/
rm -rf /root/SoftInst/Cryptos/ARG/__MACOSX/
## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  tar no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install tar
     echo ""
   fi
tar -xf /root/SoftInst/Cryptos/ARG/argentum-$UltVersARG-x86_64-linux-gnu.tar.gz
rm -rf /root/SoftInst/Cryptos/ARG/argentum-$UltVersARG-x86_64-linux-gnu.tar.gz

echo ""
echo "  Creando carpetas y archivos necesarios para ese usuario..."
echo ""
mkdir -p /home/$UsuarioNoRoot/Cryptos/ARG/ 2> /dev/null
mkdir -p /home/$UsuarioNoRoot/.argentum/
touch /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "rpcuser=argrpc"           > /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "rpcpassword=argrpcpass"  >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "rpcallowip=127.0.0.1"    >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "#Default RPC port 8766"  >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "rpcport=20401"           >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "server=1"                >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "listen=1"                >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "prune=550"               >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "daemon=1"                >> /home/$UsuarioNoRoot/.argentum/argentum.conf
echo "gen=0"                   >> /home/$UsuarioNoRoot/.argentum/argentum.conf
rm -rf /home/$UsuarioNoRoot/Cryptos/ARG/
mv /root/SoftInst/Cryptos/ARG/argentum-$UltVersARG/ /home/$UsuarioNoRoot/Cryptos/ARG/
chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/ARG/ -R
find /home/$UsuarioNoRoot/Cryptos/ARG/ -type d -exec chmod 775 {} \;
find /home/$UsuarioNoRoot/Cryptos/ARG/ -type f -exec chmod 664 {} \;
find /home/$UsuarioNoRoot/Cryptos/ARG/bin -type f -exec chmod +x {} \;

#echo ""
#echo "  Arrancando argentumd..."
#echo ""
#su $UsuarioNoRoot -c /home/$UsuarioNoRoot/Cryptos/ARG/bin/argentumd
#sleep 5
#su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/ARG/bin/argentum-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-arg.txt
#chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-arg.txt
#echo ""
#echo "  La dirección para recibir argentum es:"
#echo ""
#cat /home/$UsuarioNoRoot/pooladdress-arg.txt
#DirCartARG=$(cat /home/$UsuarioNoRoot/pooladdress-arg.txt)
#echo ""

## Autoejecución de argentum al iniciar el sistema
   #echo ""
   #echo "  Agregando argentumd a los ComandosPostArranque..."
   #echo ""
   #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-iniciar.sh
   #echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/arg-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

## Icono de lanzamiento en el menú gráfico
   echo ""
   echo "  Agregando la aplicación gráfica al menú..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
   echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   echo "Name=arg GUI"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/arg-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   echo "Categories=Cryptos"                                              >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   #echo "Icon="                                                          >> /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.local/share/applications/arg.desktop
   gio set /home/$UsuarioNoRoot/.local/share/applications/arg.desktop "metadata::trusted" yes

## Autoejecución gráfica de argentum
   echo ""
   echo "  Creando el archivo de autoejecución de argentum-qt para escritorio..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
   echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.config/autostart/arg.desktop
   echo "Name=arg GUI"                                                    >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
   echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/arg-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
   echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
   echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.config/autostart/arg.desktop
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.config/autostart/arg.desktop
   gio set /home/$UsuarioNoRoot/.config/autostart/arg.desktop "metadata::trusted" yes

## Reparación de permisos
   chmod +x /home/$UsuarioNoRoot/Cryptos/ARG/bin/*
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/ARG/ -R

## Instalar los c-scripts
   echo ""
   echo "  Instalando los c-scripts..."
   echo ""
   su $UsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
   find /home/$UsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

## Parar el daemon
   #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-parar.sh
   #su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/arg-daemon-parar.sh"
