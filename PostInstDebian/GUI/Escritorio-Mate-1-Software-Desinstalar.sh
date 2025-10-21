#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar software del escritorio Mate de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/GUI/Escritorio-Mate-1-Software-Desinstalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/GUI/Escritorio-Mate-1-Software-Desinstalar.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
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

# Ejecutar comandos dependiendo de la versión de Debian detectada
  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 13 (x)...${cFinColor}"
    echo ""

    # Desinstalar cosas específicas de mate-esktop
      sudo apt-get -y autoremove --purge xterm
      sudo apt-get -y autoremove --purge reportbug
      sudo apt-get -y autoremove --purge blender
      sudo apt-get -y autoremove --purge imagemagick
      sudo apt-get -y autoremove --purge inkscape
      sudo apt-get -y autoremove --purge gnome-disk-utility
      sudo apt-get -y autoremove --purge libreoffice-draw
      sudo apt-get -y autoremove --purge libreoffice-math
      sudo apt-get -y autoremove --purge goldendict-ng
      sudo apt-get -y autoremove --purge *fcitx5*
      sudo apt-get -y autoremove --purge xiterm+thai
      sudo apt-get -y autoremove --purge calamares*
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de software para el escritorio mate en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Desinstalar cosas específicas de mate-esktop
      sudo apt-get -y autoremove --purge xterm
      sudo apt-get -y autoremove --purge reportbug
      sudo apt-get -y autoremove --purge blender
      sudo apt-get -y autoremove --purge imagemagick
      sudo apt-get -y autoremove --purge inkscape
      sudo apt-get -y autoremove --purge gnome-disk-utility
      sudo apt-get -y autoremove --purge libreoffice-draw
      sudo apt-get -y autoremove --purge libreoffice-math
      sudo apt-get -y autoremove --purge goldendict-ng
      sudo apt-get -y autoremove --purge *fcitx5*
      sudo apt-get -y autoremove --purge xiterm+thai
      sudo apt-get -y autoremove --purge calamares*
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de software para el escritorio mate en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de software para el escritorio mate en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de software para el escritorio mate en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de software para el escritorio mate en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de software para el escritorio mate en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
