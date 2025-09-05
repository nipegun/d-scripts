#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Android Studio en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/AndroidStudio-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/AndroidStudio-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/AndroidStudio-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
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

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install curl
    echo ""
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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Android Studio para Debian 13 (x)...${cFinColor}"
    echo ""

    # Determinar la última versión
      vEnlace=$(curl -s https://developer.android.com/studio | grep -oP 'https:[^"]*android-studio-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-linux\.tar\.gz' | head -1)

    # Descargar
      echo ""
      echo "    Descargando el archivo comprimido con la última versión..."
      echo ""
      curl -L "$vEnlace" --progress-bar -o /tmp/AndroidStudio.tar.gz

    # Descomprimir
      echo ""
      echo "    Descomprimiendo..."
      echo ""
      sudo mkdir -p /opt/AndroidStudio/
      sudo tar -xvzf /tmp/AndroidStudio.tar.gz -C /opt/AndroidStudio/ --strip-components=1

    # Crear el lanzador gráfico
      echo ""
      echo "    Creando el lanzador gráfico..."
      echo ""
      echo '[Desktop Entry]'                        | sudo tee    /usr/share/applications/android-studio.desktop
      echo 'Version=1.0'                            | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Type=Application'                       | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Name=Android Studio'                    | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Exec=/opt/AndroidStudio/bin/studio.sh'  | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Icon=/opt/AndroidStudio/bin/studio.png' | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Categories=Development;IDE;'            | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Terminal=false'                         | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'StartupNotify=true'                     | sudo tee -a /usr/share/applications/android-studio.desktop

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Android Studio para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Determinar la última versión
      vEnlace=$(curl -s https://developer.android.com/studio | grep -oP 'https:[^"]*android-studio-[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-linux\.tar\.gz' | head -1)

    # Descargar
      echo ""
      echo "    Descargando el archivo comprimido con la última versión..."
      echo ""
      curl -L "$vEnlace" --progress-bar -o /tmp/AndroidStudio.tar.gz

    # Descomprimir
      echo ""
      echo "    Descompriomiendo...."
      echo ""
      sudo mkdir -p /opt/AndroidStudio/
      sudo tar -xvzf /tmp/AndroidStudio.tar.gz -C /opt/AndroidStudio/ --strip-components=1

    # Crear el lanzador gráfico
      echo ""
      echo "    Creando el lanzador gráfico..."
      echo ""
      echo '[Desktop Entry]'                        | sudo tee    /usr/share/applications/android-studio.desktop
      echo 'Version=1.0'                            | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Type=Application'                       | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Name=Android Studio'                    | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Exec=/opt/AndroidStudio/bin/studio.sh'  | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Icon=/opt/AndroidStudio/bin/studio.png' | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Categories=Development;IDE;'            | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'Terminal=false'                         | sudo tee -a /usr/share/applications/android-studio.desktop
      echo 'StartupNotify=true'                     | sudo tee -a /usr/share/applications/android-studio.desktop


  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Android Studio para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Android Studio para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Android Studio para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Android Studio para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Android Studio para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
