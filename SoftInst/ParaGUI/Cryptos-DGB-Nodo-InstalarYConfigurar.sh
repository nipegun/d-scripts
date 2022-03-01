#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar la cadena de bloques de DigiByte (DGB)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-DGB-Nodo-InstalarYConfigurar.sh | bash
#--------------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot="nipegun"

echo ""
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de la cadena de bloques de DGB...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo ""

echo ""
echo "  Determinando la última versión de digibyte core..."
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
UltVersDGB=$(curl -s https://github.com/DigiByte-Core/digibyte/releases/ | grep href | grep linux | grep -v aarch64 | head -n1 | cut -d '"' -f2 | sed 's-/v-\n-g' | grep -v down | cut -d'/' -f1)
echo ""
echo "  La última versión de DigiByte core es la $UltVersDGB"
echo ""

echo ""
echo "  Intentando descargar el archivo comprimido de la última versión..."
echo ""
mkdir -p /root/SoftInst/Cryptos/DGB/ 2> /dev/null
rm -rf /root/SoftInst/Cryptos/DGB/*
cd /root/SoftInst/Cryptos/DGB/
vLinkArchivoDentroGithub=$(curl -s https://github.com/DigiByte-Core/digibyte/releases/ | grep href | grep linux | grep -v aarch64 | head -n1 | cut -d '"' -f2 | sed 's-.tar.gz--g' | sed 's-.zip--g')
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
wget https://github.com/$vLinkArchivoDentroGithub.zip
echo ""
echo "  Pidiendo el archivo en formato tar.gz..."
echo ""
wget https://github.com/$vLinkArchivoDentroGithub.tar.gz
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
unzip /root/SoftInst/Cryptos/DGB/digibyte-$UltVersDGB-x86_64-linux-gnu.zip
mv /root/SoftInst/Cryptos/DGB/linux/digibyte-$UltVersDGB-x86_64-linux-gnu.tar.gz /root/SoftInst/Cryptos/DGB/
rm -rf /root/SoftInst/Cryptos/DGB/digibyte-$UltVersDGB-x86_64-linux-gnu.zip
rm -rf /root/SoftInst/Cryptos/DGB/linux/
rm -rf /root/SoftInst/Cryptos/DGB/__MACOSX/
## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  tar no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install tar
     echo ""
   fi
tar -xf /root/SoftInst/Cryptos/DGB/digibyte-$UltVersDGB-x86_64-linux-gnu.tar.gz
rm -rf /root/SoftInst/Cryptos/DGB/digibyte-$UltVersDGB-x86_64-linux-gnu.tar.gz

echo ""
echo "  Creando carpetas y archivos necesarios para ese usuario..."
echo ""
mkdir -p /home/$UsuarioNoRoot/Cryptos/DGB/ 2> /dev/null
mkdir -p /home/$UsuarioNoRoot/.digibyte/
touch /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "rpcuser=dgbrpc"           > /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "rpcpassword=dgbrpcpass"  >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "rpcallowip=127.0.0.1"    >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "#Default RPC port 8766"  >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "rpcport=20401"           >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "server=1"                >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "listen=1"                >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "prune=550"               >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "daemon=1"                >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
echo "gen=0"                   >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
rm -rf /home/$UsuarioNoRoot/Cryptos/DGB/
mv /root/SoftInst/Cryptos/DGB/digibyte-$UltVersDGB/ /home/$UsuarioNoRoot/Cryptos/DGB/
chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/DGB/ -R
find /home/$UsuarioNoRoot/Cryptos/DGB/ -type d -exec chmod 775 {} \;
find /home/$UsuarioNoRoot/Cryptos/DGB/ -type f -exec chmod 664 {} \;
find /home/$UsuarioNoRoot/Cryptos/DGB/bin -type f -exec chmod +x {} \;

#echo ""
#echo "  Arrancando DigiByted..."
#echo ""
#su $UsuarioNoRoot -c /home/$UsuarioNoRoot/Cryptos/DGB/bin/digibyted
#sleep 5
#su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/DGB/bin/digibyte-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-dgb.txt
#chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-dgb.txt
#echo ""
#echo "  La dirección para recibir DigiBytes es:"
#echo ""
#cat /home/$UsuarioNoRoot/pooladdress-dgb.txt
#DirCartDGB=$(cat /home/$UsuarioNoRoot/pooladdress-dgb.txt)
#echo ""

## Autoejecución de DigiByte al iniciar el sistema
   #echo ""
   #echo "  Agregando digibyted a los ComandosPostArranque..."
   #echo ""
   #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/dgb-daemon-iniciar.sh
   #echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/dgb-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

## Icono de lanzamiento en el menú gráfico
   echo ""
   echo "  Agregando la aplicación gráfica al menú..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
   echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   echo "Name=dgb GUI"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/dgb-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   echo "Categories=Cryptos"                                              >> /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   #echo "Icon="                                                          >> /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop
   gio set /home/$UsuarioNoRoot/.local/share/applications/dgb.desktop "metadata::trusted" yes

## Autoejecución gráfica de DigiByte
   echo ""
   echo "  Creando el archivo de autoejecución de digibyte-qt para escritorio..."
   echo ""
   mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
   echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.config/autostart/dgb.desktop
   echo "Name=dgb GUI"                                                    >> /home/$UsuarioNoRoot/.config/autostart/dgb.desktop
   echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.config/autostart/dgb.desktop
   echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/dgb-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.config/autostart/dgb.desktop
   echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.config/autostart/dgb.desktop
   echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.config/autostart/dgb.desktop
   gio set /home/$UsuarioNoRoot/.config/autostart/dgb.desktop "metadata::trusted" yes

## Reparación de permisos
   chmod +x /home/$UsuarioNoRoot/Cryptos/DGB/bin/*
   chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/DGB/ -R

## Instalar los c-scripts
   echo ""
   echo "  Instalando los c-scripts..."
   echo ""
   su $UsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
   find /home/$UsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

## Parar el daemon
   #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/dgb-daemon-parar.sh
   #su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/dgb-daemon-parar.sh"

