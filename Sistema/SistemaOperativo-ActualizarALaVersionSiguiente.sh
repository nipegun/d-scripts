#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar Debian a la versión inmediatamente posterior
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/SistemaOperativo-ActualizarALaVersionSiguiente.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/SistemaOperativo-ActualizarALaVersionSiguiente.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/SistemaOperativo-ActualizarALaVersionSiguiente.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
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
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 13 (Trixie) a Debian 14 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 12 (Bookworm) a Debian 13 (Trixie)...${cFinColor}"
    echo ""

    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    dpkg -C
    apt-mark showhold
    cp /etc/apt/sources.list /etc/apt/sources.list.deb9
    sed -i -e 's|bookworm|trixie|g' /etc/apt/sources.list
    apt-get -y update
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y autoclean
    shutdown -r now

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 11 (Bullseye) a Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    dpkg -C
    apt-mark showhold
    cp /etc/apt/sources.list /etc/apt/sources.list.deb9
    sed -i -e 's|bullseye|bookworm|g' /etc/apt/sources.list
    apt-get -y update
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y autoclean
    shutdown -r now

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 10 (Buster) a Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    dpkg -C
    apt-mark showhold
    cp /etc/apt/sources.list /etc/apt/sources.list.deb9
    sed -i -e 's|buster|bullseye|g' /etc/apt/sources.list
    apt-get -y update
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y autoclean
    shutdown -r now

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 9 (Stretch) a Debian 10 (Buster)...${cFinColor}"
    echo ""

    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    dpkg -C
    apt-mark showhold
    cp /etc/apt/sources.list /etc/apt/sources.list.deb9
    sed -i -e 's|stretch|buster|g' /etc/apt/sources.list
    apt-get -y update
    apt-get -y dist-upgrade
    apt-get -y autoremove
    apt-get -y autoclean
    shutdown -r now

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 8 (Jessie) a Debian 9 (Stretch)..${cFinColor}"
    echo ""

    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    dpkg -C
    apt-mark showhold
    cp /etc/apt/sources.list /etc/apt/sources.list.deb8
    sed -i -e 's|jessie|stretch|g' /etc/apt/sources.list
    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    apt-get autoremove
    shutdown -r now

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 7 (Wheezy) a Debian 8 (Jessie)...${cFinColor}"
    echo ""

    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    dpkg -C
    apt-mark showhold
    cp /etc/apt/sources.list /etc/apt/sources.list.deb8
    sed -i -e 's|wheezy|jessie|g' /etc/apt/sources.list
    apt-get -y update
    apt-get -y upgrade
    apt-get -y dist-upgrade
    apt-get autoremove
    shutdown -r now

  fi

