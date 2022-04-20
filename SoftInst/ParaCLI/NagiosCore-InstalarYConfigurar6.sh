#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar Nagios Core en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/NagiosCore-InstalarYConfigurar.sh | bash
#--------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Determinar la versión de Debian

  if [ -f /etc/os-release ]; then
    # Para systemd y freedesktop.org
      . /etc/os-release
      OS_NAME=$NAME
      OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
      OS_NAME=$(lsb_release -si)
      OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
    # Para algunas versiones de Debian sin el comando lsb_release
      . /etc/lsb-release
      OS_NAME=$DISTRIB_ID
      OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
    # Para versiones viejas de Debian.
      OS_NAME=Debian
      OS_VERS=$(cat /etc/debian_version)
  else
    # Para el viejo uname (También funciona para BSD)
      OS_NAME=$(uname -s)
      OS_VERS=$(uname -r)
  fi


if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 7 (Wheezy)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 8 (Jessie)..."
  echo "-------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 9 (Stretch)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 10 (Buster)..."
  echo "--------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Nagios Core para Debian 11 (Bullseye)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "  curl no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update
      apt-get -y install curl
      echo ""
    fi

  echo ""
  echo "  Determinando la última versión disponible en la web oficial..."
  echo ""
  UltVersNagiosCoreWeb=$(curl -s https://www.nagios.org/downloads/nagios-core/thanks/?product_download=nagioscore | sed 's->->\n-g' | grep releases | grep "tar.gz" | head -n1 | cut -d'"' -f2 | sed 's-.tar.gz--g' | cut -d'-' -f2)
  echo "    La última versión según la web oficial es la $UltVersNagiosCoreWeb."

  echo ""
  echo "  Determinando la última versión según la web de GitHub..."
  echo ""
  UltVersNagiosCoreGitHub=$(curl -s https://github.com/NagiosEnterprises/nagioscore/releases/ | grep href | grep "tar.gz" | head -n1 | cut -d'"' -f2 | sed 's-.tar.gz--g' | cut -d'-' -f2)
  echo "    La última versión según la web de GitHub es la $UltVersNagiosCoreGitHub."

  echo ""
  echo "  Descargando archivo de la última versión..."
  echo ""
  ArchUltVersNagiosCoreWeb=$(curl -s https://www.nagios.org/downloads/nagios-core/thanks/?product_download=nagioscore | sed 's->->\n-g' | grep releases | grep "tar.gz" | head -n1 | cut -d'"' -f2)
  ArchUltVersNagiosCoreGitHub=$(curl -s https://github.com/NagiosEnterprises/nagioscore/releases/ | grep href | grep "tar.gz" | head -n1 | cut -d'"' -f2)
  mkdir -p /root/SoftInst/NagiosCore/
  rm -rf /root/SoftInst/NagiosCore/*
  curl --silent $ArchUltVersNagiosCoreWeb --output /root/SoftInst/NagiosCore/nagiosweb.tar.gz
  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "  wget no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi
  wget https://github.com$ArchUltVersNagiosCoreGitHub -O /root/SoftInst/NagiosCore/nagiosgithub.tar.gz

  echo ""
  echo "  Descomprimiendo archivo descargado..."
  echo ""
  mkdir -p /root/SoftInst/NagiosCore/Web/
  mkdir -p /root/SoftInst/NagiosCore/GitHub/
  # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "  tar no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update
      apt-get -y install tar
      echo ""
    fi
  tar -xv -f /root/SoftInst/NagiosCore/nagiosweb.tar.gz    -C /root/SoftInst/NagiosCore/
  tar -xv -f /root/SoftInst/NagiosCore/nagiosgithub.tar.gz -C /root/SoftInst/NagiosCore/

fi

