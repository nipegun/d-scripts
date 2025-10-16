#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar herramientas de red en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Herramientas-Red-Instalar.sh | bash
# ----------

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Herramientas de red para CLI en Debian 13 (Trixie)..."  
  echo ""

  sudo apt-get -y update
  sudo apt-get -y install whois
  sudo apt-get -y nmap
  sudo apt-get -y nbtscan
  sudo apt-get -y mailutils
  sudo apt-get -y wireless-tools
  sudo apt-get -y wpasupplicant
  sudo apt-get -y install tshark # WireShark para terminal
  sudo apt-get -y install arp-scan
  # Crear alias para arp-scan
    echo "alias arpscan='sudo arp-scan --ouifile=/usr/share/arp-scan/ieee-oui.txt --macfile=/usr/share/arp-scan/mac-vendor.txt '" | tee -a ~/.bashrc
    source ~/.bashrc

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Herramientas de red para CLI en Debian 12 (Bookworm)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Herramientas de red para CLI en Debian Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Herramientas de red para CLI en Debian Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Herramientas de red para CLI en Debian Debian 9 (Stretch)..."  
  echo ""

  sudo apt-get -y update
  sudo apt-get -y install whois
  sudo apt-get -y nmap
  sudo apt-get -y nbtscan
  sudo apt-get -y mailutils
  sudo apt-get -y wireless-tools
  sudo apt-get -y wpasupplicant
  sudo apt-get -y install tshark # WireShark para terminal
  sudo apt-get -y install arp-scan
  # Crear alias para arp-scan
    echo "alias arpscan='sudo arp-scan --ouifile=/usr/share/arp-scan/ieee-oui.txt --macfile=/usr/share/arp-scan/mac-vendor.txt '" | tee -a ~/.bashrc
    source ~/.bashrc

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Herramientas de red para CLI en Debian Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Herramientas de red para CLI en Debian ebian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

