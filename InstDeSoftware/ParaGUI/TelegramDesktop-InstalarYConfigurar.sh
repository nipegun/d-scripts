#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar TelegramDesktop en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/TelegramDesktop-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/TelegramDesktop-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/TelegramDesktop-InstalarYConfigurar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
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


if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Telegram-Desktop para Debian 13 (x)...${cFinColor}"
  echo ""

  # Descargar el archivo comprimido
    echo ""
    echo "    Descargando el archivo comprimido"
    echo ""
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install curl
        echo ""
      fi
    curl -L https://telegram.org/dl/desktop/linux -o /tmp/telegram-desktop.tar.xz

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install tar
          echo ""
        fi
      cd /tmp
      sudo tar -xvf telegram-desktop.tar.xz

    # Mover a la carpeta de usuario
      echo ""
      echo "    Moviendo a la carpeta de usuario..."
      echo ""
      mkdir -p $HOME/AppsPortables/TelegramDesktop/ 2> /dev/null
      cp -rv /tmp/Telegram/* $HOME/AppsPortables/TelegramDesktop/

    # Descargar el icono
      echo ""
      echo "    Descargando el ícono..."
      echo ""
      # Descargar el archivo comprimido con los iconos
        # Obtener la URL del archivo
          vURLZIPIcono=$(curl -sL https://telegram.org/tour/screenshots | sed 's->->\n-g' | grep href | grep file | grep zip | cut -d'"' -f2)
        # Descargar
          sudo rm -f /tmp/TelegramLogos.zip
          curl -L "$vURLZIPIcono" -o /tmp/TelegramLogos.zip
      # Descomprimir el archivo con los iconos
        # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install unzip
            echo ""
          fi
         sudo rm -rf /tmp/TelegramLogos/
         unzip /tmp/TelegramLogos.zip -d /tmp/TelegramLogos/
      # Copiar el ícono a la carpeta final
        mv -vf /tmp/TelegramLogos/Logo.png $HOME/AppsPortables/TelegramDesktop/TelegramLogo.png

    # Crear el lanzador gráfico
      echo ""
      echo "    Creando el lanzador gráfico..."
      echo ""
      mkdir -p ~/.local/share/applications
      echo '[Desktop Entry]'                                            | tee    ~/.local/share/applications/Telegram.desktop
      echo 'Name=Telegram'                                              | tee -a ~/.local/share/applications/Telegram.desktop
      echo 'Categories=Network;InstantMessaging;'                       | tee -a ~/.local/share/applications/Telegram.desktop
      echo "Exec=$HOME//AppsPortables/TelegramDesktop/Telegram"         | tee -a ~/.local/share/applications/Telegram.desktop
      echo "Icon=$HOME//AppsPortables/TelegramDesktop/TelegramLogo.png" | tee -a ~/.local/share/applications/Telegram.desktop
      echo 'Type=Application'                                           | tee -a ~/.local/share/applications/Telegram.desktop
      echo 'Terminal=false'                                             | tee -a ~/.local/share/applications/Telegram.desktop

    # Notificar fin de ejecución del script
      echo ""
      echo "  Script de instalación de telegram-desktop, finalizado."
      echo ""
      echo "    Puedes ejecutar telegram-desktop haciendo doble click en $HOME/AppsPortables/TelegramDesktop/Telegram"
      echo "    o lanzándolo desde su correspondiente lanzador gráfico."
      echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Telegram-Desktop para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Descargar el archivo comprimido
    echo ""
    echo "    Descargando el archivo comprimido"
    echo ""
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install curl
        echo ""
      fi
    curl -L https://telegram.org/dl/desktop/linux -o /tmp/telegram-desktop.tar.xz

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install tar
          echo ""
        fi
      cd /tmp
      sudo tar -xvf telegram-desktop.tar.xz

    # Mover a la carpeta de usuario
      echo ""
      echo "    Moviendo a la carpeta de usuario..."
      echo ""
      mkdir -p $HOME/AppsPortables/TelegramDesktop/ 2> /dev/null
      cp -rv /tmp/Telegram/* $HOME/AppsPortables/TelegramDesktop/

    # Notificar fin de ejecución del script
      echo ""
      echo "  Script de instalación de telegram-desktop, finalizado."
      echo ""
      echo "    Puedes ejecutar telegram-desktop haciendo doble click en $HOME/AppsPortables/TelegramDesktop/Telegram"
      echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Telegram-Desktop para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo "    Descargando el archivo tar..." 
  echo ""
  sudo mkdir -p /root/SoftInst/TelegramDesktop/ 2> /dev/null
  cd /root/SoftInst/TelegramDesktop/
  sudo curl -sL https://telegram.org/dl/desktop/linux -o /root/SoftInst/TelegramDesktop/telegram-desktop-setup.tar.xz

  echo ""
  echo "    Descomprimiendo del archivo..." 
  echo ""
  # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}      tar no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install tar
      echo ""
    fi
   sudo tar -xvf /root/SoftInst/TelegramDesktop/telegram-desktop-setup.tar.xz

  echo ""
  echo "    Moviendo los archivos a la carpeta del usuario no-root..." 
  echo ""
  sudo mkdir -p /home/$vUsuarioNoRoot/AppsPortables/TelegramDesktop/ 2> /dev/null
  sudo cp -r /root/SoftInst/TelegramDesktop/Telegram/* /home/$vUsuarioNoRoot/AppsPortables/TelegramDesktop/

  echo ""
  echo "    Asignando propiedad y reparando permisos..." 
  echo ""
  sudo chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/AppsPortables/ -v
  sudo chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/AppsPortables/TelegramDesktop/ -Rv
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Telegram-Desktop para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Telegram-Desktop para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Telegram-Desktop para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Telegram-Desktop para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi
