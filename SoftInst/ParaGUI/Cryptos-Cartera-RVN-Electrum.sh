#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar la cartera de RVN Electrum en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Cartera-RVN-Electrum.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Cartera-RVN-Electrum.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Cartera-RVN-Electrum.sh | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de la cartera RVN Electrum para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Borrar archivos de ejecuciones anteriores
    rm -rf /root/SoftInst/ElectrumRavencoin/ 2> /dev/null

  echo ""
  echo "  Determinando última versión del código fuente..."
  echo ""
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    curl no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install curl
      echo ""
    fi
  vAppImage=$(curl -s https://github.com/Electrum-RVN-SIG/electrum-ravencoin/releases | sed 's->-\n-g' | grep ownload | grep href | grep mage | head -n1 | cut -d'"' -f2)
  vUltVersCodFuente=$(curl -s https://github.com/Electrum-RVN-SIG/electrum-ravencoin/releases | sed 's->-\n-g' | grep href | grep ".tar.gz" | head -n1 | cut -d'"' -f2 | cut -d'/' -f7 | sed 's-.tar.gz--g')
  echo ""
  echo "    La última versión es la $vUltVersCodFuente"
  echo ""

  echo ""
  echo "  Determinando la URL del archivo a descargar..."
  echo ""
  vURLArchivo=$(curl -s https://github.com/Electrum-RVN-SIG/electrum-ravencoin/releases/tag/$vUltVersCodFuente | grep href | grep ".tar.gz" | cut -d'"' -f2)
  echo ""
  echo "    La URL del archivo a descargar es https://github.com$vURLArchivo"
  echo ""

  echo ""
  echo "  Descargando el archivo del código fuente... "
  echo ""
  mkdir -p /root/SoftInst/ElectrumRavencoin/ 2> /dev/null
  cd /root/SoftInst/ElectrumRavencoin/
  curl -sL https://github.com"$vURLArchivo" -o /root/SoftInst/ElectrumRavencoin/CodFuente.tar.gz

  echo ""
  echo "  Descomprimiendo el archivo descargado... "
  echo ""
  # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    tar no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install tar
      echo ""
    fi
  cd /root/SoftInst/ElectrumRavencoin/
  tar -xvzf /root/SoftInst/ElectrumRavencoin/CodFuente.tar.gz
  find /root/SoftInst/ElectrumRavencoin/ -type d -exec mv {} /root/SoftInst/ElectrumRavencoin/CodFuente \;

  echo ""
  echo "  Instalando paquetes necesarios..."
  echo ""
  apt-get -y update
  apt-get -y install python3
  apt-get -y install python3-venv
  apt-get -y install cmake
  apt-get -y install python3-cryptography
  apt-get -y install libsecp256k1-0
  apt-get -y install python3-pyqt5

  #apt-get -y install python3-pip
  #pip3 install virtualenv

  #echo ""
  #echo "  ..."
  #echo ""
  #./electrum-env

  #apt-get -y install automake
  #apt-get -y install libtool
  #./contrib/make_libsecp256k1.sh

fi
