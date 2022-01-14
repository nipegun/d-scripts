#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar VirtualBox en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Escritorio/VirtualBox-Instalar.sh | bash
#----------------------------------------------------------------------------------------------------------------------

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
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de VirtualBox para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de VirtualBox para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de VirtualBox para Debian 9 (Stretch)..."
  echo "------------------------------------------------------------------------------"
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

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de VirtualBox para Debian 10 (Buster)..."
  echo "------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de VirtualBox para Debian 11 (Bullseye)..."
  echo "--------------------------------------------------------------------------------"
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
     wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
     wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
     echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bullseye contrib" > /etc/apt/sources.list.d/virtualbox.list
     apt-get -y update

  ## Instalar virtualbox
     echo ""
     echo "  Instalando el paquete virtualbox..."
     echo ""

  ## Instalar el pack de extensiones
     echo ""
     echo "  Instalando el pack de extensiones..."
     echo ""
     cd /root/SoftInst/VirtualBox/
     wget https://download.virtualbox.org/virtualbox/6.1.24/Oracle_VM_VirtualBox_Extension_Pack-6.1.24.vbox-extpack
     vboxmanage extpack install --replace /root/SoftInst/VirtualBox/Oracle_VM_VirtualBox_Extension_Pack-6.1.24.vbox-extpack

   ## Agregar el usuario 1000 al grupo virtualbox
      echo ""
      echo "  Agregando el usuario 1000 en el grupo virtualbox..."
      echo ""
      usermod -a G vboxusers 1000
fi

