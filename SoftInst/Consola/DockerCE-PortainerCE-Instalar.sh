#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar PortainerCE en el DockerCE de Debian
#
# Ejecución remota
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/DockerCE-PortainerCE-Instalar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------

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
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de PortainerCE en el DockerCE de Debian 7 (Wheezy)..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de PortainerCE en el DockerCE de Debian 8 (Jessie)..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de PortainerCE en el DockerCE de Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de PortainerCE en el DockerCE de Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""
 
elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de PortainerCE en el DockerCE de Debian 11 (Bullseye)..."
  echo "-----------------------------------------------------------------------------------------------"
  echo ""

  ## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update > /dev/null
       apt-get -y install dialog
       echo ""
     fi
  menu=(dialog --timeout 5 --checklist "¿Donde quieres instalar PortainerCE?:" 22 76 16)
    opciones=(1 "En un ordenador o máquina virtual" on
              2 "En un contenedor LXC de Proxmox" off
              3 "..." off
              4 "..." off)
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
              echo ""
              echo -e "${ColorVerde}  Instalando PortainerCE en un ordenador o máquina virtual...${FinColor}"
              echo ""
              mkdir -p /root/portainer/data 2> /dev/null
              docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
              echo "docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer" >> /root/scripts/ComandosPostArranque.sh
            ;;

            2)
              echo ""
              echo -e "${ColorVerde}  Instalando PortainerCE en un contenedor LXC...${FinColor}"
              echo ""
              mkdir -p /Host/Portainer/ 2> /dev/null
              docker run -d -p 9000:9000 -v /Host/Portainer:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
              echo "docker run -d -p 9000:9000 -v /root/portainer/data:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer" >> /root/scripts/ComandosPostArranque.sh
            ;;

            3)
              echo ""
              echo -e "${ColorVerde}  ...${FinColor}"
              echo ""
            ;;

            4)
              echo ""
              echo -e "${ColorVerde}  ...${FinColor}"
              echo ""
            ;;
        
          esac

        done

fi

