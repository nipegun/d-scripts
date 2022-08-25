#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar la cadena de bloques de Chia (XCH)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-RVN-InstalarYConfigurar.sh | bash
# ----------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot="nipegun"

echo ""
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de la cadena de bloques de RVN...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------------------------${FinColor}"
echo ""

echo ""
echo "  Determinando la última versión de raven core..."
echo ""
# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  curl no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi
UltVersRaven=$(curl --silent -L https://github.com/RavenProject/Ravencoin/releases/latest | grep inux | grep href | grep -v isable | cut -d'"' -f2 | cut -d '/' -f 6 | cut -c2- | head -n1)
echo ""
echo "    La última versión de raven es la $UltVersRaven"
echo ""

echo ""
echo "  Determinando el nombre del archivo tar de la versión $UltVersRaven..."
echo ""
vNombreArchivo=$(curl -sL https://github.com/RavenProject/Ravencoin/releases/latest/ | grep href | grep inux | grep -v isable | grep x86 | cut -d'"' -f2 | cut -d '/' -f7)
echo ""
echo "    El nombre del archivo es $vNombreArchivo"
echo ""

echo ""
echo "  Intentando descargar el archivo..."
echo ""
mkdir -p /root/SoftInst/Cryptos/RVN/ 2> /dev/null
rm -rf /root/SoftInst/Cryptos/RVN/*
cd /root/SoftInst/Cryptos/RVN/
# Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  wget no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update && apt-get -y install wget
    echo ""
  fi
wget https://github.com/RavenProject/Ravencoin/releases/download/v$UltVersRaven/$vNombreArchivo

echo ""
echo "  Descomprimiendo el archivo..."
echo ""
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  tar no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update && apt-get -y install tar
    echo ""
  fi
tar -xf /root/SoftInst/Cryptos/RVN/$vNombreArchivo
rm -rf /root/SoftInst/Cryptos/RVN/$vNombreArchivo
find /root/SoftInst/Cryptos/RVN/ -type d -name "raven*" -exec mv {} /root/SoftInst/Cryptos/RVN/"raven-$UltVersRaven"/ \; 2> /dev/null

echo ""
echo "  Creando carpetas y archivos necesarios para ese usuario..."
echo ""
mkdir -p /home/$UsuarioNoRoot/.raven/
touch /home/$UsuarioNoRoot/.raven/raven.conf
echo "rpcuser=rvnrpc"           > /home/$UsuarioNoRoot/.raven/raven.conf
echo "rpcpassword=rvnrpcpass"  >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "rpcallowip=127.0.0.1"    >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "#Default RPC port 8766"  >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "rpcport=20401"           >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "server=1"                >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "listen=1"                >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "prune=550"               >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "daemon=1"                >> /home/$UsuarioNoRoot/.raven/raven.conf
echo "gen=0"                   >> /home/$UsuarioNoRoot/.raven/raven.conf
rm -rf /home/$UsuarioNoRoot/Cryptos/RVN/
mkdir -p /home/$UsuarioNoRoot/Cryptos/RVN/ 2> /dev/null
mv /root/SoftInst/Cryptos/RVN/raven-$UltVersRaven/ /home/$UsuarioNoRoot/Cryptos/RVN/
chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/RVN/ -R
find /home/$UsuarioNoRoot/Cryptos/RVN/ -type d -exec chmod 775 {} \;
find /home/$UsuarioNoRoot/Cryptos/RVN/ -type f -exec chmod 664 {} \;
find /home/$UsuarioNoRoot/Cryptos/RVN/bin -type f -exec chmod +x {} \;

#echo ""
#echo "  Arrancando ravencoind..."
#echo ""
#su $UsuarioNoRoot -c /home/$UsuarioNoRoot/Cryptos/RVN/bin/ravend
#sleep 5
#su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/Cryptos/RVN/bin/raven-cli getnewaddress" > /home/$UsuarioNoRoot/pooladdress-rvn.txt
#chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/pooladdress-rvn.txt
#echo ""
#echo "  La dirección para recibir ravencoins es:"
#echo ""
#cat /home/$UsuarioNoRoot/pooladdress-rvn.txt
#DirCartRVN=$(cat /home/$UsuarioNoRoot/pooladdress-rvn.txt)
#echo ""

# Autoejecución de Ravencoin al iniciar el sistema
  #echo ""
  #echo "  Agregando ravend a los ComandosPostArranque..."
  #echo ""
  #chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/rvn-daemon-iniciar.sh
  #echo "su "$UsuarioNoRoot" -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/rvn-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

# Icono de lanzamiento en el menú gráfico
  echo ""
  echo "  Agregando la aplicación gráfica al menú..."
  echo ""
  mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
  echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  echo "Name=rvn GUI"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/rvn-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  echo "Categories=Cryptos"                                              >> /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  #echo "Icon="                                                          >> /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop
  gio set /home/$UsuarioNoRoot/.local/share/applications/rvn.desktop "metadata::trusted" yes

# Autoejecución gráfica de Ravencoin
  echo ""
  echo "  Creando el archivo de autoejecución de raven-qt para escritorio..."
  echo ""
  mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
  echo "[Desktop Entry]"                                                  > /home/$UsuarioNoRoot/.config/autostart/rvn.desktop
  echo "Name=rvn GUI"                                                    >> /home/$UsuarioNoRoot/.config/autostart/rvn.desktop
  echo "Type=Application"                                                >> /home/$UsuarioNoRoot/.config/autostart/rvn.desktop
  echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/rvn-gui-iniciar.sh"  >> /home/$UsuarioNoRoot/.config/autostart/rvn.desktop
  echo "Terminal=false"                                                  >> /home/$UsuarioNoRoot/.config/autostart/rvn.desktop
  echo "Hidden=false"                                                    >> /home/$UsuarioNoRoot/.config/autostart/rvn.desktop
  gio set /home/$UsuarioNoRoot/.config/autostart/rvn.desktop "metadata::trusted" yes

# Reparación de permisos
  chmod +x /home/$UsuarioNoRoot/Cryptos/RVN/bin/*
  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/Cryptos/RVN/ -R
  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.raven/ -R
  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/.local/share/applications/ -R

# Instalar los c-scripts
  echo ""
  echo "  Instalando los c-scripts..."
  echo ""
  su $UsuarioNoRoot -c "curl --silent https://raw.githubusercontent.com/nipegun/c-scripts/main/CScripts-Instalar.sh | bash"
  find /home/$UsuarioNoRoot/scripts/c-scripts/ -type f -iname "*.sh" -exec chmod +x {} \;

# Parar el daemon
  chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/rvn-daemon-parar.sh
  su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/rvn-daemon-parar.sh"
