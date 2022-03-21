#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar el dibujador del mapa para el servidor gaming de MinecraftJE
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Gaming-MinecraftJE-DibujadorDeMapa-Instalar.sh | bash
#-----------------------------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de MinecraftJE para Debian 7 (Wheezy)..."
  echo "---------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de MinecraftJE para Debian 8 (Jessie)..."
  echo "---------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de MinecraftJE para Debian 9 (Stretch)..."
  echo "----------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de MinecraftJE para Debian 10 (Buster)..."
  echo "----------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${ColorVerde}Instalando el dibujador del mapa...${FinColor}"
  echo ""

  apt-get -y update > /dev/null
  apt-get -y install python3-pil
  apt-get -y install python3-dev
  apt-get -y install python3-numpy
  apt-get -y install git
  apt-get -y install unzip
  mkdir -p /root/SoftInst/ 2> /dev/null
  cd /root/SoftInst/
  rm -rf /root/SoftInst/Minecraft-Overviewer/
  git clone git://github.com/overviewer/Minecraft-Overviewer.git
  cd Minecraft-Overviewer
  python3 setup.py build
  ln -s /root/SoftInst/Minecraft-Overviewer/overviewer.py /usr/local/bin/mcoverviewer
  
  unzip -p /home/mcserver/serverfiles/minecraft_server.jar version.json > /tmp/version.json
  ServerVersion=$(cat /tmp/version.json | grep arget | cut -d'"' -f4)
  mkdir -p /root/.minecraft/versions/${ServerVersion}/
  wget https://overviewer.org/textures/${ServerVersion} -O /root/.minecraft/versions/${ServerVersion}/${ServerVersion}.jar

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de MinecraftJE para Debian 11 (Bullseye)..."
  echo "------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${ColorVerde}Instalando el dibujador del mapa...${FinColor}"
  echo ""

  apt-get -y update > /dev/null
  apt-get -y install python3-pil
  apt-get -y install python3-dev
  apt-get -y install python3-numpy
  apt-get -y install git
  apt-get -y install unzip
  mkdir -p /root/SoftInst/ 2> /dev/null
  cd /root/SoftInst/
  rm -rf /root/SoftInst/Minecraft-Overviewer/
  git clone git://github.com/overviewer/Minecraft-Overviewer.git
  cd Minecraft-Overviewer
  python3 setup.py build
  ln -s /root/SoftInst/Minecraft-Overviewer/overviewer.py /usr/local/bin/mcoverviewer
  
  unzip -p /home/mcserver/serverfiles/minecraft_server.jar version.json > /tmp/version.json
  ServerVersion=$(cat /tmp/version.json | grep arget | cut -d'"' -f4)
  mkdir -p /root/.minecraft/versions/${ServerVersion}/
  wget https://overviewer.org/textures/${ServerVersion} -O /root/.minecraft/versions/${ServerVersion}/${ServerVersion}.jar

fi

