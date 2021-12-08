#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar Docker y Portainer en Debian
#
# Ejecución remota
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/DockerYPortainer-Instalar.sh | bash
#------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

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
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Docker y Portainer para Debian 7 (Wheezy)..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Docker y Portainer para Debian 8 (Jessie)..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Docker y Portainer para Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Docker y Portainer para Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  apt-get update
  apt-get -y install docker-ce
  mkdir -p /root/portainer/data 2> /dev/null
  docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
  echo "docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer" >> /root/scripts/ComandosPostArranque.sh
  systemctl enable docker
  systemctl start docker
 
elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de Docker y Portainer para Debian 11 (Bullseye)..."
  echo "-----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Instalando paquetes necesarios..."
  echo ""
  apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common

  echo ""
  echo "  Descargando la clave PGP del KeyRing..."
  echo ""
  wget -O- https://download.docker.com/linux/debian/gpg  gpg --dearmor | tee /usr/share/keyrings/docker-archive-keyring.gpg

  echo ""
  echo "  Agregando el repositorio..."
  echo ""
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  apt-get update

  echo ""
  echo "  Instalando docker-ce..."
  echo ""
  apt-get -y install docker-ce

  echo ""
  echo "  Instalando Portainer..."
  echo ""
  mkdir -p /root/portainer/data 2> /dev/null
  docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
  echo "docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer" >> /root/scripts/ComandosPostArranque.sh

  echo ""
  echo "  Activando y arrancando el servicio de docker..."
  echo ""
  systemctl enable docker
  systemctl start docker

fi

