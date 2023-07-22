#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

---------
# Script de NiPeGun para instalar y configurar ProxmoxVE en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Proxmox-VirtualizationEnvironment-Instalar.sh | bash
---------

# Definir fecha de ejecución del script
  cFechaDeEjec=$(date +a%Ym%md%d@%T)

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de ProxmoxVE para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de ProxmoxVE para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de ProxmoxVE para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de ProxmoxVE para Debian 10 (Buster)..."  
  echo ""

  apt-get -y update
  apt-get -y install wget
  echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/ProxmoxVE.list
  wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmomx-ve-release-buster.gpg
  apt-get -y update
  echo "127.0.0.1 $HOSTNAME" > /etc/hosts
  apt-get -y install proxmox-ve
  rm -rf /etc/apt/sources.list.d/pve-enterprise.list
  apt-get -y update
  apt-get -y install pve-headers
  cp /etc/network/interfaces /etc/network/interfaces.bak.$cFechaDeEjec

  # Desinstalar
  # touch /please-remove-proxmox-ve
  # apt-get -y purge proxmox-ve

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de ProxmoxVE para Debian 11 (Bullseye)..."  
  echo ""

  apt-get -y update
  apt-get -y install wget
  echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/ProxmoxVE.list
  wget http://download.proxmox.com/debian/proxmox-ve-release-buulseye.gpg -O /etc/apt/trusted.gpg.d/proxmomx-ve-release-bullseye.gpg
  apt-get -y update
  echo "127.0.0.1 $HOSTNAME" > /etc/hosts
  apt-get -y install proxmox-ve
  rm -rf /etc/apt/sources.list.d/pve-enterprise.list
  apt-get -y update
  apt-get -y install pve-headers
  cp /etc/network/interfaces /etc/network/interfaces.bak.$cFechaDeEjec

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de ProxmoxVE para Debian 12 (Bookworm)..."  
  echo ""

  apt-get -y update
  apt-get -y install wget
  echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/ProxmoxVE.list
  wget http://download.proxmox.com/debian/proxmox-ve-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmomx-ve-release-bookworm.gpg
  apt-get -y update
  echo "127.0.0.1 $HOSTNAME" > /etc/hosts
  apt-get -y install proxmox-ve
  rm -rf /etc/apt/sources.list.d/pve-enterprise.list
  apt-get -y update
  apt-get -y install pve-headers
  cp /etc/network/interfaces /etc/network/interfaces.bak.$cFechaDeEjec

  # Desinstalar
  # touch /please-remove-proxmox-ve
  # apt-get -y purge proxmox-ve

fi

