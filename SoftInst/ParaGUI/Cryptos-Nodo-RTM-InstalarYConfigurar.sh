#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

---
# Script de NiPeGun para instalar y configurar la cadena de bloques de Raptoreum (RTM)
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-RTM-InstalarYConfigurar.sh | bash
---

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

vUsuarioNoRoot="nipegun"

echo ""
echo -e "${cColorVerde}------------------------------------------------------------------------${cFinColor}"
echo -e "${cColorVerde}  Iniciando el script de instalación de la cadena de bloques de RTM...${cFinColor}"
echo -e "${cColorVerde}------------------------------------------------------------------------${cFinColor}"
echo ""

echo ""
echo "  Determinando la última versión estable de raptoreum..."
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
vUltVersRTM=$(curl -sL https://github.com/Raptor3um/raptoreum/releases/latest | sed 's->->\n-g' | grep ".zip" | grep "href" | grep -v indows | cut -d '"' -f2 | cut -d '/' -f7 | sed 's-.zip--g')
echo ""
echo "    La última versión estable de raptoreum es la $vUltVersRTM"
echo ""

echo ""
echo "  Borrando archivos de instalaciónes anteriores..."
echo ""
rm -rf /root/SoftInst/Cryptos/RTM/*
killall -9 raptoreum*
rm -rf /home/$vUsuarioNoRoot/Cryptos/RTM/* -R
rm -rf /home/$vUsuarioNoRoot/.raptoreumcore/ -R
rm -f  /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
rm -f  /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
rm -rf /home/$vUsuarioNoRoot/.config/Raptoreum/ -R
rm -f  /home/$vUsuarioNoRoot/dircartera-rtm.txt

echo ""
echo "  Intentando descargar el archivo comprimido de la última versión..."
echo ""
mkdir -p /root/SoftInst/Cryptos/RTM/ 2> /dev/null
cd /root/SoftInst/Cryptos/RTM/
# Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "    wget no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update 2> /dev/null && apt-get -y install wget
     echo ""
   fi
vURLArchivo=$(curl -sL https://github.com/Raptor3um/raptoreum/releases/latest | sed 's->->\n-g' | grep .tar.gz | grep href | grep buntu2 | tail -n1 | cut -d'"' -f2)
echo ""
echo "    Pidiendo el archivo en formato tar.gz..."
echo ""
wget https://github.com$vURLArchivo -O /root/SoftInst/Cryptos/RTM/Raptoreum.tar.gz

echo ""
echo "  Descomprimiendo el archivo..."
echo ""
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  tar no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update > /dev/null && apt-get -y install tar
    echo ""
  fi
tar -xvf /root/SoftInst/Cryptos/RTM/Raptoreum.tar.gz

echo ""
echo "  Creando carpetas y archivos necesarios para ese usuario..."
echo ""
mkdir -p /home/$vUsuarioNoRoot/.raptoreumcore/
touch /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "rpcuser=rtmrpc"           > /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "rpcpassword=rtmrpcpass"  >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "rpcallowip=127.0.0.1"    >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "#Default RPC port 8766"  >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "rpcport=60226"           >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "server=1"                >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "listen=1"                >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
#echo "prune=550"               >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "daemon=1"                >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
echo "gen=0"                   >> /home/$vUsuarioNoRoot/.raptoreumcore/raptoreum.conf
rm -rf /home/$vUsuarioNoRoot/Cryptos/RTM/
mkdir -p /home/$vUsuarioNoRoot/Cryptos/RTM/bin/ 2> /dev/null
mv /root/SoftInst/Cryptos/RTM/raptoreum-cli /home/$vUsuarioNoRoot/Cryptos/RTM/bin/
mv /root/SoftInst/Cryptos/RTM/raptoreum-qt  /home/$vUsuarioNoRoot/Cryptos/RTM/bin/
mv /root/SoftInst/Cryptos/RTM/raptoreum-tx  /home/$vUsuarioNoRoot/Cryptos/RTM/bin/
mv /root/SoftInst/Cryptos/RTM/raptoreumd    /home/$vUsuarioNoRoot/Cryptos/RTM/bin/
chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/RTM/ -R
find /home/$vUsuarioNoRoot/Cryptos/RTM/ -type d -exec chmod 775 {} \;
find /home/$vUsuarioNoRoot/Cryptos/RTM/ -type f -exec chmod 664 {} \;
find /home/$vUsuarioNoRoot/Cryptos/RTM/bin/ -type f -exec chmod +x {} \;
chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.raptoreumcore/ -R

echo ""
echo "  Arrancando raptoreumd..."
echo ""
su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/RTM/bin/raptoreumd -daemon"
sleep 5
su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/Cryptos/RTM/bin/raptoreum-cli getnewaddress" > /home/$vUsuarioNoRoot/dircartera-rtm.txt
chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/dircartera-rtm.txt
echo ""
echo "  La dirección para recibir raptoreum es:"
echo ""
cat /home/$vUsuarioNoRoot/dircartera-rtm.txt
vDirCartRTM=$(cat /home/$vUsuarioNoRoot/dircartera-rtm.txt)
echo ""

# Autoejecución de raptoreum al iniciar el sistema
  #echo ""
  #echo "  Agregando raptoreumd a los ComandosPostArranque..."
  #echo ""
  #chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/rtm-daemon-iniciar.sh
  #echo "su "$vUsuarioNoRoot" -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/rtm-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

# Icono de lanzamiento en el menú gráfico
  echo ""
  echo "  Agregando la aplicación gráfica al menú..."
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
  echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  echo "Name=rtm GUI"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/rtm-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  echo "Categories=Cryptos"                                               >> /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  #echo "Icon="                                                           >> /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop
  gio set /home/$vUsuarioNoRoot/.local/share/applications/rtm.desktop "metadata::trusted" yes

# Autoejecución gráfica de raptoreum
  echo ""
  echo "  Creando el archivo de autoejecución de raptoreum-qt para escritorio..."
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
  echo "[Desktop Entry]"                                                   > /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
  echo "Name=rtm GUI"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
  echo "Type=Application"                                                 >> /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/rtm-gui-iniciar.sh"  >> /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
  echo "Terminal=false"                                                   >> /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
  echo "Hidden=false"                                                     >> /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop
  gio set /home/$vUsuarioNoRoot/.config/autostart/rtm.desktop "metadata::trusted" yes

# Reparación de permisos
  chmod +x /home/$vUsuarioNoRoot/Cryptos/RTM/bin/*
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/Cryptos/RTM/ -R
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.raptoreumcore/ -R
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.local/share/applications/ -R
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/.config/autostart/ -R

# Instalar los c-scripts
  echo ""
  echo "  Instalando los c-scripts..."
  echo ""
  su $vUsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
  find /home/$vUsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

# Parar el daemon
  chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/rtm-daemon-parar.sh
  su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/rtm-daemon-parar.sh"

