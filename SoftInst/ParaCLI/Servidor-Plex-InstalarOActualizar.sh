#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor Plex en Debian
#
# Ejecución remota:
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Plex-InstalarOActualizar.sh | bash
#----------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

CarpetaAlternativa="/Discos/HDD-Datos/Plex"

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
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor Plex para Debian 7 (Wheezy)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor Plex para Debian 8 (Jessie)..."
  echo "----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor Plex para Debian 9 (Stretch)..."
  echo "-----------------------------------------------------------------------------------"
  echo ""

  ColorVerde="\033[1;32m"
  FinColor="\033[0m"

  menu=(dialog --timeout 5 --checklist "Elección de la arquitectura:" 22 76 16)
    opciones=(1 "Instalar o actualizar versión x86 de 32 bits" off
              2 "Instalar o actualizar versión x86 de 64 bits" off
              3 "Instalar o actualizar versión ARMv7" off
              4 "Instalar o actualizar versión ARMv8" off)
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    clear

    for choice in $choices
      do
        case $choice in

          1)
            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura x86 de 32 bits...${FinColor}"
            echo ""
            mkdir /root/paquetes
            mkdir /root/paquetes/plex 
            cd /root/paquetes/plex
            rm -f /root/paquetes/plex/plex32x86.deb

            echo ""
            echo -e "${ColorVerde}Descargando el paquete de instalación...${FinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/plex/plex32x86.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            dpkg -i /root/paquetes/plex/plex32x86.deb
          
            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start
          ;;

          2)
            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura x86 de 64 bits...${FinColor}"
            echo ""
            mkdir /root/paquetes
            mkdir /root/paquetes/plex 
            cd /root/paquetes/plex
            rm -f /root/paquetes/plex/plex64x86.deb

            echo ""
            echo -e "${ColorVerde}Descargando el paquete de instalación...${FinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/plex/plex64x86.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            dpkg -i /root/paquetes/plex/plex64x86.deb
          
            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start
          ;;

          3)
            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura ARMv7 (armhf)...${FinColor}"
            echo ""
            mkdir /root/paquetes
            mkdir /root/paquetes/plex 
            cd /root/paquetes/plex
            rm -f /root/paquetes/plex/plexARMv7.deb

            echo ""
            echo "Descargando el paquete de instalación..."
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/plex/plexARMv7.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            dpkg -i /root/paquetes/plex/plexARMv7.deb

            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start
          ;;

          4)
            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura ARMv7 (arm64)...${FinColor}"
            echo ""
            mkdir /root/paquetes
            mkdir /root/paquetes/plex 
            cd /root/paquetes/plex
            rm -f /root/paquetes/plex/plexARMv8.deb

            echo ""
            echo -e "${ColorVerde}Descargando el paquete de instalación...${FinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/plex/plexARMv8.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            dpkg -i /root/paquetes/plex/plexARMv8.deb
          
            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start
          ;;

        esac

  done

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor Plex para Debian 10 (Buster)..."
  echo "-----------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor Plex para Debian 11 (Bullseye)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  ## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install dialog
       echo ""
     fi

  menu=(dialog --timeout 5 --checklist "Elección de la arquitectura:" 22 76 16)
    opciones=(1 "Instalar o actualizar versión x86 de 32 bits" off
              2 "Instalar o actualizar versión x86 de 64 bits" off
              3 "Instalar o actualizar versión ARMv7" off
              4 "Instalar o actualizar versión ARMv8" off
              5 "Cambiar la carpeta por defecto de Plex" off)
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices

        do

          case $choice in

          1)

            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura x86 de 32 bits...${FinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/plex32x86.deb

            echo ""
            echo -e "${ColorVerde}Descargando el paquete de instalación...${FinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/plex/plex32x86.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            dpkg -i /root/SoftInst/Plex/plex32x86.deb
          
            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start

          ;;

          2)

            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura x86 de 64 bits...${FinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/plex64x86.deb

            echo ""
            echo -e "${ColorVerde}Descargando el paquete de instalación...${FinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/plex/plex64x86.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            dpkg -i /root/SoftInst/Plex/plex64x86.deb
          
            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start

          ;;

          3)

            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura ARMv7 (armhf)...${FinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/plexARMv7.deb

            echo ""
            echo "Descargando el paquete de instalación..."
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/plex/plexARMv7.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            dpkg -i /root/SoftInst/Plex/plexARMv7.deb
          
            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start

          ;;

          4)

            echo ""
            echo -e "${ColorVerde}Instalando Plex para arquitectura ARMv7 (arm64)...${FinColor}"
            echo ""
            mkdir /root/SoftInst/Plex/
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/plexARMv8.deb

            echo ""
            echo -e "${ColorVerde}Descargando el paquete de instalación...${FinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/plex/plexARMv8.deb

            echo ""
            echo -e "${ColorVerde}Deteniendo el servicio plexmediaserver (si es que está activo)...${FinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${ColorVerde}Instalando el paquete...${FinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            dpkg -i /root/SoftInst/Plex/plexARMv8.deb
          
            echo ""
            echo -e "${ColorVerde}Arrancando el servicio plexediaserver...${FinColor}"
            echo ""
            service plexmediaserver start

          ;;

          5)
           systemctl stop plexmediaserver.service
           mkdir -p /etc/systemd/system/plexmediaserver.service.d/ 2> /dev/null
           touch /etc/systemd/system/plexmediaserver.service.d/override.conf
           echo "[Service]" > /etc/systemd/system/plexmediaserver.service.d/override.conf
           echo 'Environment="PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=$CarpetaAlternativa"' >> /etc/systemd/system/plexmediaserver.service.d/override.conf
           systemctl daemon-reload
           systemctl start plexmediaserver.service
           systemctl status plexmediaserver.service

          ;;

        esac

      done

fi

