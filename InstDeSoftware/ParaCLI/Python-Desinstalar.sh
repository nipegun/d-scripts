#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar python de Debian
#
# Ejecución remota con sudo:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Desinstalar.sh | sudo bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Desinstalar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Python-Desinstalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de python para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de python para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Desinstalar python2
      sudo apt-get -y autoremove python2*
    # Desinstalar python3
      sudo apt-get -y autoremove python3-dev
      sudo apt-get -y autoremove python3-anyio
      sudo apt-get -y autoremove python3-asttokens
      sudo apt-get -y autoremove python3-attr
      sudo apt-get -y autoremove python3-brotli
      sudo apt-get -y autoremove python3-bs4
      sudo apt-get -y autoremove python3-capstone
      sudo apt-get -y autoremove python3-yara
      sudo apt-get -y autoremove python3-venv
      sudo apt-get -y autoremove python3-pycryptodome
      sudo apt-get -y autoremove python3-distorm3
      sudo apt-get -y autoremove python3-pip
      sudo apt-get -y autoremove python3-argcomplete
      sudo apt-get -y autoremove python3-psutil
      sudo apt-get -y autoremove python3-pyelftools
      sudo apt-get -y autoremove python3-pygments
      sudo apt-get -y autoremove python3-pymodbus
      sudo apt-get -y autoremove python3-pymysql
      sudo apt-get -y autoremove python3-pyqt5
      sudo apt-get -y autoremove python3-pyqt5.qtsvg
      sudo apt-get -y autoremove python3-pyqt5.qtwebsockets
      sudo apt-get -y autoremove python3-pyzbar
      sudo apt-get -y autoremove python3-regex
      sudo apt-get -y autoremove python3-requests-toolbelt
      sudo apt-get -y autoremove python3-samba
      sudo apt-get -y autoremove python3-scapy
      sudo apt-get -y autoremove python3-serial
      sudo apt-get -y autoremove python3-serial-asyncio
      sudo apt-get -y autoremove python3-setuptools-whl
      sudo apt-get -y autoremove python3-smbc
      sudo apt-get -y autoremove python3-sniffio
      sudo apt-get -y autoremove python3-sympy
      sudo apt-get -y autoremove python3-talloc
      sudo apt-get -y autoremove python3-tdb
      sudo apt-get -y autoremove python3-tk
      sudo apt-get -y autoremove python3-typer
      sudo apt-get -y autoremove python3-ujson
      sudo apt-get -y autoremove python3-uno
      sudo apt-get -y autoremove python3-webencodings
      sudo apt-get -y autoremove python3-wrapt
      sudo apt-get -y autoremove python3-xdg
      sudo apt-get -y autoremove python3-xlib
      sudo apt-get -y autoremove python3-construct
      sudo apt-get -y autoremove python3-cups
      sudo apt-get -y autoremove python3-cupshelpers
      sudo apt-get -y autoremove python3-dnspython
      sudo apt-get -y autoremove python3-et-xmlfile
      sudo apt-get -y autoremove python3-gpg
      sudo apt-get -y autoremove python3-h2
      sudo apt-get -y autoremove python3-hpack
      sudo apt-get -y autoremove python3-hyperframe
      sudo apt-get -y autoremove python3-ibus-1.0
      sudo apt-get -y autoremove python3-jdcal
      sudo apt-get -y autoremove python3-json-pointer
      sudo apt-get -y autoremove python3-jsonschema
      sudo apt-get -y autoremove python3-ldb
      sudo apt-get -y autoremove python3-libvirt
      sudo apt-get -y autoremove python3-libxml2
      sudo apt-get -y autoremove python3-lxml
      sudo apt-get -y autoremove python3-mako
      sudo apt-get -y autoremove python3-markdown
      sudo apt-get -y autoremove python3-markupsafe
      sudo apt-get -y autoremove python3-numpy
      sudo apt-get -y autoremove python3-olefile
      sudo apt-get -y autoremove python3-opencv
      sudo apt-get -y autoremove python3-openpyxl
      sudo apt-get -y autoremove python3-openssl
      sudo apt-get -y autoremove python3-packaging
      sudo apt-get -y autoremove python3-pil
      sudo apt-get -y autoremove python3-pil.imagetk
      sudo apt-get -y autoremove python3-pip-whl

      sudo apt-get -y autoremove python3-wheel     # También borra ROCm y archivos asociados
      sudo apt-get -y autoremove python3-socks     # También borra TOR browser-launcher
      sudo apt-get -y autoremove python3-pyqt5.sip # También borra TOR browser-launcher
      sudo apt-get -y autoremove python3-binwalk   # También borra binwalk y mtd-utils
      sudo apt-get -y autoremove python3-cairo     # Tambien borra system-config-printer

      #sudo apt-get autoremove python3-wadllib             # No se puede borrar en gnome
      #sudo apt-get autoremove python3-software-properties # No se puede borrar en gnome
      #sudo apt-get autoremove python3-pyparsing           # No se puede borrar en gnome
      #sudo apt-get autoremove python3-apt                 # No se puede borrar en gnome
      #sudo apt-get autoremove python3-blinker             # No se puede borrar en gnome
      #sudo apt-get autoremove python3-cffi-backend        # No se puede borrar en gnome
      #sudo apt-get autoremove python3-cryptography        # No se puede borrar en gnome
      #sudo apt-get autoremove python3-dateutil            # No se puede borrar en gnome
      #sudo apt-get autoremove python3-dbus                # No se puede borrar en gnome
      #sudo apt-get autoremove python3-distro              # No se puede borrar en gnome
      #sudo apt-get autoremove python3-distro-info         # No se puede borrar en gnome
      #sudo apt-get autoremove python3-gi                  # No se puede borrar en gnome
      #sudo apt-get autoremove python3-httplib2            # No se puede borrar en gnome
      #sudo apt-get autoremove python3-lazr.restfulclient  # No se puede borrar en gnome
      #sudo apt-get autoremove python3-lazr.uri            # No se puede borrar en gnome
      #sudo apt-get autoremove python3-oauthlib            # No se puede borrar en gnome

      #sudo apt-get autoremove python3-pyvmomi            # No es aconsejable borrar en proxmox porque borra pve-esxi-import-tools
      #sudo apt-get autoremove python3-requests           # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-six                # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-systemd            # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-urllib3            # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-wcwidth            # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-yaml               # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-setuptools         # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-distutils          # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-rbd                # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-rados              # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-protobuf           # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-ceph-argparse      # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-ceph-common        # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-cephfs             # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-certifi            # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-chardet            # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-charset-normalizer # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-distutils          # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-idna               # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-jwt                # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-lib2to3            # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-minimal            # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-pkg-resources      # No se puede borrar en proxmox
      #sudo apt-get autoremove python3-prettytable        # No se puede borrar en proxmox

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de python para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de python para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de python para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de python para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de desinstalación de python para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

