#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar software en el escritorio Gnome de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInst/GUI/Escritorio-Gnome-Software-Desinstalar.sh | sudo bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInst/GUI/Escritorio-Gnome-Software-Desinstalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInst/GUI/Escritorio-Gnome-Software-Desinstalar.sh | nano -
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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script instalación de software para el escritorio Gnome en Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Desinstalar escoria de gnome
      echo ""
      echo "  Desinstalando escoria de Gnome..."
      echo ""
      apt-get -y remove xterm
      #apt-get -y remove reportbug
      #apt-get -y remove blender
      #apt-get -y remove imagemagick
      #apt-get -y remove inkscape
      apt-get -y remove rhythmbox
      apt-get -y remove evolution
      apt-get -y remove gnome-2048
      apt-get -y remove five-or-more
      apt-get -y remove four-in-a-row
      apt-get -y remove kasumi
      #apt-get -y remove ghcal
      apt-get -y remove hitori
      apt-get -y remove gnome-klotski
      apt-get -y remove lightsoff
      apt-get -y remove gnome-mahjongg
      apt-get -y remove gnome-mines
      apt-get -y remove mlterm
      apt-get -y remove gnome-music
      apt-get -y remove gnome-nibbles
      apt-get -y remove quadrapassel
      apt-get -y remove iagno
      apt-get -y remove gnome-robots
      apt-get -y remove gnome-sudoku
      apt-get -y remove swell-foop
      apt-get -y remove gnome-tetravex
      apt-get -y remove gnome-taquin
      apt-get -y remove aisleriot
      apt-get -y remove tali
      apt-get -y remove totem
      apt-get -y remove gnome-chess
      apt-get -y remove gnome-maps
      apt-get -y remove gnome-weather
      apt-get -y autoremove

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script instalación de software para el escritorio Gnome en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Desinstalar escoria de gnome
      echo ""
      echo "  Desinstalando escoria de Gnome..."
      echo ""
      apt-get -y remove xterm
      apt-get -y remove reportbug
      apt-get -y remove blender
      apt-get -y remove imagemagick
      apt-get -y remove inkscape
      apt-get -y remove rhythmbox
      apt-get -y remove evolution
      apt-get -y remove gnome-2048
      apt-get -y remove five-or-more
      apt-get -y remove four-in-a-row
      apt-get -y remove kasumi
      apt-get -y remove ghcal
      apt-get -y remove hitori
      apt-get -y remove gnome-klotski
      apt-get -y remove lightsoff
      apt-get -y remove gnome-mahjongg
      apt-get -y remove gnome-mines
      apt-get -y remove mlterm
      apt-get -y remove gnome-music
      apt-get -y remove gnome-nibbles
      apt-get -y remove quadrapassel
      apt-get -y remove iagno
      apt-get -y remove gnome-robots
      apt-get -y remove gnome-sudoku
      apt-get -y remove swell-foop
      apt-get -y remove gnome-tetravex
      apt-get -y remove gnome-taquin
      apt-get -y remove aisleriot
      apt-get -y remove tali
      apt-get -y remove totem
      apt-get -y remove gnome-chess
      apt-get -y remove gnome-maps
      apt-get -y gnome-weather
      apt-get -y autoremove

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
