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

# IP Local
  #cIPLocal="$(hostname -I)"
  cIPLocal="192.168.1.200"
  cCIDR="24"
  cIPGateway="192.168.1.1"

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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 7 (Wheezy)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 8 (Jessie)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 9 (Stretch)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 10 (Buster)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 11 (Bullseye)...${cFinColor}"  
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ProxmoxVE para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi

  # Agregar el repositorio de proxmox
    echo ""
    echo "    Agregando el repositorio re Proxmox..."
    echo ""
    echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/ProxmoxVE.list

  # Agregar a llave para firmar las descargas desde el repositorio de Proxmox
    echo ""
    echo "    Agregando a llave para firmar las descargas desde el repositorio de Proxmox..."
    echo ""
    wget http://download.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmomx-release-bookworm.gpg

  # Actualizar la lista de paquetes disponibles en los repositorios activados
    echo ""
    echo "    Actualizar la lista de paquetes disponibles en los repositorios activados..."
    echo ""
    apt-get -y update

  # Configurar la red
    echo ""
    echo "    Configurando la red..."
    echo ""
    # /etc/hosts
      echo ""
      echo "      Editando el archivo /etc/hosts..."
      echo ""
      cp /etc/hosts /etc/hosts.bak.$cFechaDeEjec
      echo "127.0.0.1 $HOSTNAME"                      > /etc/hosts
      echo "$cIPLocal $HOSTNAME $HOSTNAME.home.arpa" >> /etc/hosts
      echo ""
      echo "        El archivo /etc/hosts ha quedado así:"
      echo ""
      cat /etc/hosts
      echo ""
    # /etc/network/interfaces
      echo ""
      echo "      Editando el archivo /etc/network/interfaces..."
      echo ""
      cp /etc/network/interfaces /etc/network/interfaces.bak.$cFechaDeEjec
      echo "auto lo"                      > /etc/network/interfaces
      echo "iface lo inet loopback"      >> /etc/network/interfaces
      echo ""                            >> /etc/network/interfaces
      echo "iface eth0 inet static"      >> /etc/network/interfaces
      echo "  address $cIPLocal/$cCIDR"  >> /etc/network/interfaces
      echo "  gateway $cIPGateway"       >> /etc/network/interfaces
      echo "" >> /etc/network/interfaces
      echo ""
      echo "        El archivo /etc/network/interfaces ha quedado así:"
      echo ""
      cat /etc/network/interfaces
      echo ""
    # Reiniciar el servicio de networking
      echo ""
      echo "    Re-iniciando el servicio de networking"
      echo ""
      service networking restart

  # Instalar el paqete proxmox-ve
    echo ""
    echo "    Instalando el paquete proxmox-ve..."
    echo ""
    apt-get -y install proxmox-ve

  # Borrar el repositorio enterprise
    echo ""
    echo "    Desactivando el repositorio enterprise..."
    echo ""
    rm -rf /etc/apt/sources.list.d/pve-enterprise.list

  # Volver a actualizar la lista de paquetes disponibles en los repositorios activados
    echo ""
    echo "    Volviendo a actualizar la lista de paquetes disponibles en los repositorios activados..."
    echo ""
    apt-get -y update

  # Instalar las cabeceras del kernel
    echo ""
    echo "    Instalando las cabeceras del kernel..."
    echo ""
    apt-get -y install pve-headers
    
  # Notificar fin de la instalación
    echo ""
    echo -e "${cColorVerde}    Ejecución del script, finalizada.${cFinColor}"
    echo ""
    echo -e "${cColorVerde}      Para desinstalar Proxmox ejecuta:${cFinColor}"
    echo -e "${cColorVerde}        touch /please-remove-proxmox-ve${cFinColor}"
    echo -e "${cColorVerde}        apt-get -y purge proxmox-ve${cFinColor}"
    echo ""

fi

