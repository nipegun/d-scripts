#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

-------------
# Script de NiPeGun para instalar el servidor gaming de Call of Duty 4 Modern Warfare
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Gaming-CoD4Server-InstalarYConfigurar.sh | bash
-------------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de Call of Duty 4 Modern Warfare para Debian 7 (Wheezy)..."  echo "---------------------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de Call of Duty 4 Modern Warfare para Debian 8 (Jessie)..."  echo "---------------------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de Call of Duty 4 Modern Warfare para Debian 9 (Stretch)..."  echo "----------------------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de Call of Duty 4 Modern Warfare para Debian 10 (Buster)..."  echo "----------------------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo -e "${cColorVerde}  Instalando el servidor cod4server...${cFinColor}"
  echo ""

  echo ""
  echo "  Instalando dependencias..." 
echo ""
  dpkg --add-architecture i386
  apt-get -y update
  apt-get -y install mailutils
  apt-get -y install postfix
  apt-get -y install curl
  apt-get -y install wget
  apt-get -y install file
  apt-get -y install tar
  apt-get -y install bzip2
  apt-get -y install gzip
  apt-get -y install unzip
  apt-get -y install bsdmainutils
  apt-get -y install python
  apt-get -y install util-linux
  apt-get -y install ca-certificates
  apt-get -y install binutils
  apt-get -y install bc
  apt-get -y install jq
  apt-get -y install tmux
  apt-get -y install lib32gcc1
  apt-get -y install libstdc++6
  apt-get -y install lib32stdc++6
  apt-get -y install steamcmd

  echo ""
  echo "  Dependencias instaladas."
  echo "  Revisa el script porque hay comandos que tendrás que ejecutar manualmente"
  echo "  para terminar de instalar el servidor de CoD4MW."
  echo ""

  # A partir de aquí, ejecución manual
  # adduser cod4server
  # su - cod4server
  # wget -O linuxgsm.sh https://linuxgsm.sh
  # chmod +x linuxgsm.sh
  # bash linuxgsm.sh cod4server
  # ./cod4server install

  # Cómo administrarlo
  #
  #./cod4server start
  #./cod4server stop
  #./cod4server restart
  #./cod4server details
  #./cod4server debug
  #./cod4server backup
  #./cod4server monitor
  #./cod4server console 
  #  To exit the console press CTRL+b d. Pressing CTRL+c will terminate the server.
  #  
  #Logs
  #Server logs are available to monitor and diagnose your server. Script, console and game server (if available) logs are created for the server.
  #/home/cod4server/logs

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "------------------------------------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor gaming de Call of Duty 4 Modern Warfare para Debian 11 (Bullseye)..."  echo "------------------------------------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Instalando dependencias..." 
echo ""
  dpkg --add-architecture i386
  apt-get -y update
  apt-get -y install mailutils
  apt-get -y install postfix
  apt-get -y install curl
  apt-get -y install wget
  apt-get -y install file
  apt-get -y install tar
  apt-get -y install bzip2
  apt-get -y install gzip
  apt-get -y install unzip
  apt-get -y install bsdmainutils
  apt-get -y install python
  apt-get -y install util-linux
  apt-get -y install ca-certificates
  apt-get -y install binutils
  apt-get -y install bc
  apt-get -y install jq
  apt-get -y install tmux
  apt-get -y install lib32gcc-s1
  apt-get -y install libstdc++6
  apt-get -y install lib32stdc++6
  apt-get -y install steamcmd

  echo ""
  echo "  Dependencias instaladas."
  echo "  Revisa el script porque hay comandos que tendrás que ejecutar manualmente"
  echo "  para terminar de instalar el servidor de CoD4MW."
  echo ""

  # A partir de aquí, ejecución manual
  # adduser cod4server
  # su - cod4server
  # wget -O linuxgsm.sh https://linuxgsm.sh
  # chmod +x linuxgsm.sh
  # bash linuxgsm.sh cod4server
  # ./cod4server install

  # Cómo administrarlo
  #
  #./cod4server start
  #./cod4server stop
  #./cod4server restart
  #./cod4server details
  #./cod4server debug
  #./cod4server backup
  #./cod4server monitor
  #./cod4server console 
  #  To exit the console press CTRL+b d. Pressing CTRL+c will terminate the server.
  #  
  #Logs
  #Server logs are available to monitor and diagnose your server. Script, console and game server (if available) logs are created for the server.
  #/home/cod4server/logs

fi

