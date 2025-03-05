#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

---
# Script de NiPeGun para instalar y configurar la cadena de bloques de DigiByte (DGB)
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-DGB-InstalarYConfigurar.sh | bash
---

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

vUsuarioNoRoot="nipegun"

echo ""
echo -e "${cColorAzulClaro}  Iniciando el script de instalación del nodo Digibyte (DGB)...${cFinColor}"
echo ""

echo ""
echo "    Determinando la última versión estable de digibyte core..."
echo ""
# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
     echo ""
     apt-get -y update
     apt-get -y install curl
     echo ""
   fi
cUltVersDGB=$(curl -sL https://github.com/DigiByte-Core/digibyte/releases/latest | sed 's->-\n>-'g | grep tag | sed 's-tag/-\n-g' | grep ^v | cut -d'"' -f1 | head -n1 | sed 's-v--g')
echo ""
echo "      La última versión estable de DigiByte core es la $cUltVersDGB"
echo ""

echo ""
echo "    Intentando descargar el archivo comprimido de la última versión..."
echo ""
mkdir -p /root/SoftInst/Cryptos/DGB/ 2> /dev/null
rm -rf /root/SoftInst/Cryptos/DGB/*
cd /root/SoftInst/Cryptos/DGB/
# Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "      El paquete wget no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install wget
     echo ""
   fi
wget https://github.com/DigiByte-Core/digibyte/releases/download/v"$cUltVersDGB"/digibyte-"$cUltVersDGB"-x86_64-linux-gnu.tar.gz -O /root/SoftInst/Cryptos/DGB/DigibyteCore.tar.gz

echo ""
echo "    Descomprimiendo el archivo..."
echo ""
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "      El paquete tar no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install tar
     echo ""
   fi
tar -xf /root/SoftInst/Cryptos/DGB/DigibyteCore.tar.gz
rm -rf /root/SoftInst/Cryptos/DGB/DigibyteCore.tar.gz

echo ""
echo "    Creando carpetas y archivos necesarios para ese usuario..."
echo ""
# Crear la carpeta en la home del usuario no root
  mkdir -p /home/$vUsuarioNoRoot/Cryptos/DGB/ 2> /dev/null
  rm -rf /home/$vUsuarioNoRoot/Cryptos/DGB/
  mv /root/SoftInst/Cryptos/DGB/digibyte-$cUltVersDGB/ /home/$vUsuarioNoRoot/Cryptos/DGB/
# Crear archivo de configuración cli
  mkdir -p /home/$vUsuarioNoRoot/.digibyte/ 2> /dev/null
  #touch /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "rpcuser=dgbrpc"           > /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "rpcpassword=dgbrpcpass"  >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "rpcallowip=127.0.0.1"    >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "#Default RPC port xxxx"  >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "rpcport=20410"           >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "server=1"                >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "listen=1"                >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "prune=550"               >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "daemon=1"                >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
  #echo "gen=0"                   >> /home/$UsuarioNoRoot/.digibyte/digibyte.conf
# Crear archivo de configuración gráfica
  mkdir -p /home/$vUsuarioNoRoot/.config/DigiByte/ 2> /dev/null
  touch /home/$vUsuarioNoRoot/.config/DigiByte/DigiByte-Qt.conf
  echo "strDataDir=/home/$vUsuarioNoRoot/.digibyte" > /home/$vUsuarioNoRoot/.config/DigiByte/DigiByte-Qt.conf
# Reparar permisos
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/DGB/ -R
  find /home/$vUsuarioNoRoot/Cryptos/DGB/ -type d -exec chmod 775 {} \;
  find /home/$vUsuarioNoRoot/Cryptos/DGB/ -type f -exec chmod 664 {} \;
  find /home/$vUsuarioNoRoot/Cryptos/DGB/bin -type f -exec chmod +x {} \;


# Instalar paquetes necesarios
  sudo apt-get -y install libxcb-icccm4
  sudo apt-get -y install libxcb-image0
  sudo apt-get -y install libxcb-keysyms1
  sudo apt-get -y install libxcb-render-util0
  sudo apt-get -y install libxcb-xinerama0
## Arrancar el nodo
#  echo ""
#  echo "    Arrancando digibyted..."
#  echo ""
#  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.digibyte/ -R
#  su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/DGB/bin/digibyted -daemon"
#  sleep 5
#  su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/DGB/bin/digibyte-cli getnewaddress" > /home/$vUsuarioNoRoot/dgb-address.txt
#  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/dgb-address.txt
#  echo ""
#  echo "      La dirección para recibir DigiBytes es:"
#  echo ""
#  cat /home/$vUsuarioNoRoot/dgb-address.txt
#  vDirCartDGB=$(cat /home/$vUsuarioNoRoot/dgb-address.txt)
#  echo ""

# Autoejecución de DigiByte al iniciar el sistema
  #echo ""
  #echo "    Agregando digibyted a los ComandosPostArranque..."
  #echo ""
  #chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/dgb-daemon-iniciar.sh
  #echo "su "$vUsuarioNoRoot" -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/dgb-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

# Icono de lanzamiento en el menú gráfico
  echo ""
  echo "    Agregando la aplicación gráfica al menú..." 
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
  echo "[Desktop Entry]"                                                  > /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  echo "Name=Nodo GUI"                                                   >> /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  echo "Type=Application"                                                >> /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/dgb-gui-iniciar.sh" >> /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  echo "Terminal=false"                                                  >> /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  echo "Hidden=false"                                                    >> /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  echo "Categories=Cryptos"                                              >> /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  #echo "Icon="                                                          >> /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  chown $vUsuarioNoRoot:$vUsuarioNoRoot                                     /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop
  gio set /home/$vUsuarioNoRoot/.local/share/applications/nodo-dgb.desktop "metadata::trusted" yes

# Autoejecución gráfica de DigiByte
  echo ""
  echo "    Creando el archivo de autoejecución de digibyte-qt para escritorio..." 
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
  echo "[Desktop Entry]"                                                  > /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop
  echo "Name=Noddo DGB"                                                  >> /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop
  echo "Type=Application"                                                >> /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/dgb-gui-iniciar.sh" >> /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop
  echo "Terminal=false"                                                  >> /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop
  echo "Hidden=false"                                                    >> /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop
  chown $vUsuarioNoRoot:$vUsuarioNoRoot                                     /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop
  gio set /home/$vUsuarioNoRoot/.config/autostart/nodo-dgb.desktop "metadata::trusted" yes

# Reparación de permisos
   chmod +x /home/$vUsuarioNoRoot/Cryptos/DGB/bin/*
   chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/DGB/ -R

# Instalar los c-scripts
  echo ""
  echo "    Instalando los c-scripts..." 
  echo ""
  su $vUsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
  find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

# Parar el daemon
  chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/dgb-daemon-parar.sh
  su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/dgb-daemon-parar.sh"

echo ""
echo "    Nodo instalado."
echo "    El puerto a abrir es el 12024"
echo ""
