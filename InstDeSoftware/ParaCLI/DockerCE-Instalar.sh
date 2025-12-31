#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Docker y Portainer en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/DockerCE-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/DockerCE-Instalar.sh | sed 's-sudo--g' | bash
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
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de DockerCE para Debian 13 (x)..."
  echo ""

  echo ""
  echo "  Instalando paquetes necesarios..."
  echo ""
  sudo apt-get -y install wget
  sudo apt-get -y install apt-transport-https
  sudo apt-get -y install ca-certificates
  sudo apt-get -y install curl
  sudo apt-get -y install gnupg2
  sudo apt-get -y install software-properties-common
  sudo apt-get -y install lsb-release

  echo ""
  echo "  Descargando la clave PGP del KeyRing..."
  echo ""
  sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg 2> /dev/null
  wget -O- https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo ""
  echo "  Agregando el repositorio..."
  echo ""
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt-get -y update

  echo ""
  echo "  Instalando docker-ce..."
  echo ""
  sudo apt-get -y install docker-ce

  echo ""
  echo "  Activando e iniciando el servicio de docker..."
  echo ""
  sudo systemctl enable docker --now

  echo ""
  echo "  Mostrando el estado del servicio de docker..."
  echo ""
  sudo systemctl status docker --no-pager

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de DockerCE para Debian 12 (Bookworm)..."
  echo ""

  echo ""
  echo "  Instalando paquetes necesarios..."
  echo ""
  sudo apt-get -y install wget
  sudo apt-get -y install apt-transport-https
  sudo apt-get -y install ca-certificates
  sudo apt-get -y install curl
  sudo apt-get -y install gnupg2
  sudo apt-get -y install software-properties-common
  sudo apt-get -y install lsb-release

  echo ""
  echo "  Descargando la clave PGP del KeyRing..."
  echo ""
  sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg 2> /dev/null
  wget -O- https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo ""
  echo "  Agregando el repositorio..."
  echo ""
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt-get -y update

  echo ""
  echo "  Instalando docker-ce..."
  echo ""
  sudo apt-get -y install docker-ce

  echo ""
  echo "  Activando e iniciando el servicio de docker..."
  echo ""
  sudo systemctl enable docker --now

  echo ""
  echo "  Mostrando el estado del servicio de docker..."
  echo ""
  sudo systemctl status docker --no-pager

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de DockerCE para Debian 11 (Bullseye)..."
  echo ""

  echo ""
  echo "  Instalando paquetes necesarios..."
  echo ""
  apt-get -y install wget
  apt-get -y install apt-transport-https
  apt-get -y install ca-certificates
  apt-get -y install curl
  apt-get -y install gnupg2
  apt-get -y install software-properties-common

  echo ""
  echo "  Descargando la clave PGP del KeyRing..."
  echo ""
  wget -O- https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  echo ""
  echo "  Agregando el repositorio..."
  echo ""
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
  apt-get update

  echo ""
  echo "  Instalando docker-ce..."
  echo ""
  apt-get -y install docker-ce

  echo ""
  echo "  Activando y arrancando el servicio de docker..."
  echo ""
  systemctl enable docker
  systemctl start docker

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de DockerCE para Debian 10 (Buster)..."
  echo ""

  apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  apt-get update
  apt-get -y install docker-ce
  systemctl enable docker
  systemctl start docker

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de DockerCE para Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de DockerCE para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de DockerCE para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

fi

