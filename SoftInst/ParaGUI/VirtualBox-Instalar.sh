#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar VirtualBox en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/VirtualBox-Instalar.sh | bash
# ----------

# Definir variables de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de VirtualBox para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de VirtualBox para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de VirtualBox para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  AGREGANDO EL REPOSITORIO"
  echo ""
  echo "deb http://download.virtualbox.org/virtualbox/debian stretch contrib" > /etc/apt/sources.list.d/virtualbox.list

  echo ""
  echo "  AGREGANDO LA LLAVE"
  echo ""
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -

  echo ""
  echo "  ACTUALIZANDO EL SISTEMA"
  echo ""
  apt-get update

  echo ""
  echo "  INSTALANDO EL PAQUETE"
  echo ""
  apt-get -y install virtualbox-5.1

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de VirtualBox para Debian 10 (Buster)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de VirtualBox para Debian 11 (Bullseye)..."
  
  echo ""

  ## Instalar paquetes necesarios
     echo ""
     echo "  Instalando paquetes necesarios..."
     echo ""
     apt-get -y update
     apt-get -y install linux-headers-$(uname -r)
     apt-get -y install dkms

  ## Agregar repositorio
     echo ""
     echo "  Agregando repositorio de VirtualBox..."
     echo ""
     apt-get -y install gnupg2
     ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  wget no está instalado. Iniciando su instalación..."
          echo ""
          apt-get -y update > /dev/null
          apt-get -y install wget
          echo ""
        fi
     wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
     wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
     echo "deb [arch=$(dpkg --print-architecture)] http://download.virtualbox.org/virtualbox/debian bullseye contrib" > /etc/apt/sources.list.d/virtualbox.list
     apt-get -y update

  ## Instalar virtualbox
     echo ""
     echo "  Instalando el paquete virtualbox..."
     echo ""
     PaqueteAInstalar=$(apt-cache search virtualbox | grep "virtualbox-" | tail -n1 | cut -d' ' -f1)
     apt-get -y install $PaqueteAInstalar

  ## Instalar el pack de extensiones
     echo ""
     echo "  Instalando el pack de extensiones..."
     echo ""
     mkdir -p /root/SoftInst/VirtualBox/
     cd /root/SoftInst/VirtualBox/
     VersDeVBoxInstalada=$(virtualbox -h | grep elector | cut -d'v' -f2)
     wget https://download.virtualbox.org/virtualbox/$VersDeVBoxInstalada/Oracle_VM_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack
     vboxmanage extpack install --replace /root/SoftInst/VirtualBox/Oracle_VM_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack

   ## Agregar el usuario 1000 al grupo virtualbox
      echo ""
      echo "  Agregando el usuario 1000 en el grupo virtualbox..."
      echo ""
      Usuario1000=$(id 1000 | cut -d'(' -f2 | cut -d')' -f1)
      usermod -a -G vboxusers $Usuario1000

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VirtualBox para Debian 12 (Bookworm)..."
  echo ""

  # Instalar paquetes necesarios
    echo ""
    echo "  Instalando paquetes necesarios..."
    echo ""
    apt-get -y update
    apt-get -y install linux-headers-$(uname -r)
    apt-get -y install dkms

  # Agregar repositorio
    echo ""
    echo "  Agregando repositorio de VirtualBox..."
    echo ""
    apt-get -y install gnupg2
    # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  wget no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install wget
        echo ""
      fi
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
    echo "deb [arch=$(dpkg --print-architecture)] http://download.virtualbox.org/virtualbox/debian bookworm contrib" > /etc/apt/sources.list.d/virtualbox.list
    apt-get -y update

  # Instalar virtualbox
    echo ""
    echo "  Instalando el paquete virtualbox..."
    echo ""
    PaqueteAInstalar=$(apt-cache search virtualbox | grep "virtualbox-" | tail -n1 | cut -d' ' -f1)
    apt-get -y install $PaqueteAInstalar

  # Instalar el pack de extensiones
    echo ""
    echo "  Instalando el pack de extensiones..."
    echo ""
    mkdir -p /root/SoftInst/VirtualBox/
    cd /root/SoftInst/VirtualBox/
    VersDeVBoxInstalada=$(virtualbox -h | grep elector | cut -d'v' -f2)
    wget https://download.virtualbox.org/virtualbox/$VersDeVBoxInstalada/Oracle_VM_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack
    vboxmanage extpack install --replace /root/SoftInst/VirtualBox/Oracle_VM_VirtualBox_Extension_Pack-$VersDeVBoxInstalada.vbox-extpack

   # Agregar el usuario 1000 al grupo virtualbox
     echo ""
     echo "  Agregando el usuario 1000 en el grupo virtualbox..."
     echo ""
     Usuario1000=$(id 1000 | cut -d'(' -f2 | cut -d')' -f1)
     usermod -a -G vboxusers $Usuario1000

fi

