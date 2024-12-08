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

  # Crear el menú
    # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install dialog
        echo ""
      fi
    menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      opciones=(
        1 "Instalar desde repos (forma oficial de debian)" off
        2 "Instalar desde web"                              on
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando desde repos..."
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
              /usr/games/steam

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

            ;;

            2)

              echo ""
              echo "  Instalando desde la web..."
              echo ""
              dpkg --add-architecture i386
              mkdir -p /root/SoftInst/Steam/ 2> /dev/null
              rm -rf /root/SoftInst/Steam/*  2> /dev/null
              # Descargar el .deb
                # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    apt-get -y update
                    apt-get -y install curl
                    echo ""
                  fi
                curl -sL https://cdn.fastly.steamstatic.com/client/installer/steam.deb -o /root/SoftInst/Steam/Steam.deb
              # Instalar dependencias
                apt-get -y update
                apt-get -y install mesa-vulkan-drivers
                apt-get -y install libglx-mesa0:i386
                apt-get -y install mesa-vulkan-drivers:i386
                apt-get -y install libgl1-mesa-dri:i386
                apt-get -y install libgtk2.0-0:i386
                apt-get -y install libgl1-mesa-glx:i386
                apt-get -y install libc6:i386
                apt-get -y install libc6:amd64
                apt-get -y install libegl1:amd64
                apt-get -y install libegl1:i386
                apt-get -y install libgbm1:amd64
                apt-get -y install libgbm1:i386
                apt-get -y install libgl1-mesa-dri:amd64
                apt-get -y install libgl1-mesa-dri:i386
                apt-get -y install libgl1:amd64
                apt-get -y install libgl1:i386
                apt-get -y install steam-libs-amd64:amd64
              # Instlar paquete
                apt -y install /root/SoftInst/Steam/Steam.deb

            ;;

        esac

    done

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

