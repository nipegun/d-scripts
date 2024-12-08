#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Steam en Debian
#
# Ejecución remota con sudo:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Steam-Instalar.sh | sudo bash
#
# Ejecución remota con root:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Steam-Instalar.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 13 (x)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 12 (Bookworm)..."  
  echo ""
  dpkg --add-architecture i386
  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Repositorios-Todos-Poner.sh | bash
  apt-get -y update
  apt-get -y install mesa-vulkan-drivers
  apt-get -y install libglx-mesa0:i386
  apt-get -y install mesa-vulkan-drivers:i386
  apt-get -y install libgl1-mesa-dri:i386
  apt-get -y install libgtk2.0-0:i386
  apt-get -y install libgl1-mesa-glx:i386
  apt-get -y install libc6:i386
  apt-get -y install steam-installer
  echo ""
  echo "  Se procederá ahora con la instalación de steam."
  echo "  Cuando acabe, y llegues a la ventana de inicio de sesión, no te loguees y cierra la ventana."
  echo ""
  read -p "  Presiona Enter para continuar..." < /dev/tty
  steam

  # Borrar las librerías que tienen conflicto con debian
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libstdc++.so.6
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/i386/lib/i386-linux-gnu/libgcc_s.so.1
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu/libgcc_s.so.1
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libstdc++.so.6
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libxcb.so.1
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/i386/lib/i386-linux-gnu/libgpg-error.so.0

  # Borrar archivos que puedan hacer que no haya sonido en los juegos
    rm -rf ~/.steam/debian-installation/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/alsa-lib
    rm -rf ~/.steam/debian-installation/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/alsa-lib
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libasound.so.*
    rm ~/.steam/debian-installation/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu/libasound.so.*

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 10 (Buster)..."  
  echo ""

  apt-get -y update
  apt-get -y install wget gdebi
  mkdir -p /root/paquetes/steam
  cd /root/paquetes/steam
  wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
  gdebi /root/paquetes/steam/steam.deb
  dpkg --add-architecture i386
  apt-get update
  apt-get -y install libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Steam para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

