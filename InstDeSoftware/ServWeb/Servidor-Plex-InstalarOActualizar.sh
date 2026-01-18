#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el servidor Plex en Debian
#
# Ejecución remota (puede requerir permisos sido):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Plex-InstalarOActualizar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-Plex-InstalarOActualizar.sh | sed 's-sudo--g' | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

CarpetaAlternativa="/Discos/HDD-Datos/Plex"

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor Plex para Debian 13 (x)..."
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  El paquete dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install dialog
       echo ""
     fi

  menu=(dialog --checklist "Elección de la arquitectura:" 22 76 16)
    opciones=(
      1 "Instalar o actualizar versión x86 de 32 bits" off
      2 "Instalar o actualizar versión x86 de 64 bits" off
      3 "Instalar o actualizar versión ARMv7"          off
      4 "Instalar o actualizar versión ARMv8"          off
      5 "Cambiar la carpeta por defecto de Plex"       off
    )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices

        do

          case $choice in

          1)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura x86 de 32 bits...${cFinColor}"
            echo ""
            sudo mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            sudo rm -f /root/SoftInst/Plex/Plex32x86.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            sudo cd /root/SoftInst/Plex/
            sudo wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/Plex32x86.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            sudo systemctl stop plexmediaserver

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            sudo apt-get -y install beignet-opencl-icd
            sudo apt-get -y install ocl-icd-libopencl1
            sudo apt -y install /root/SoftInst/Plex/Plex32x86.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            sudo systemctl enable plexmediaserver
            sudo systemctl start plexmediaserver

          ;;

          2)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura x86 de 64 bits...${cFinColor}"
            echo ""
            sudo mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            sudo rm -f /root/SoftInst/Plex/Plex64x86.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            sudo cd /root/SoftInst/Plex/
            sudo wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/Plex64x86.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            sudo systemctl stop plexmediaserver

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install ocl-icd-libopencl1
            sudo apt-get -y install gnupg2
            # sudo mkdir -p /etc/systemd/system/plexmediaserver.service.d/
            # echo '[Service]'                                                     | sudo tee    /etc/systemd/system/plexmediaserver.service.d/override.conf
            # echo 'Environment="PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/Host"' | sudo tee -a /etc/systemd/system/plexmediaserver.service.d/override.conf
            sudo apt -y install /root/SoftInst/Plex/Plex64x86.deb

            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            sudo systemctl enable plexmediaserver
            sudo systemctl start plexmediaserver

          ;;

          3)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura ARMv7 (armhf)...${cFinColor}"
            echo ""
            sudo mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            sudo rm -f /root/SoftInst/Plex/PlexARMv7.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            sudo cd /root/SoftInst/Plex/
            sudo wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/PlexARMv7.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            sudo systemctl stop plexmediaserver

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            sudo apt-get -y install beignet-opencl-icd
            sudo apt-get -y install ocl-icd-libopencl1
            sudo apt -y install /root/SoftInst/Plex/PlexARMv7.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            sudo systemctl enable plexmediaserver
            sudo systemctl start plexmediaserver

          ;;

          4)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura ARMv8 (arm64)...${cFinColor}"
            echo ""
            sudo mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            sudo rm -f /root/SoftInst/Plex/PlexARMv8.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            sudo cd /root/SoftInst/Plex/
            sudo wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/PlexARMv8.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            sudo systemctl stop plexmediaserver

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            sudo apt-get -y install beignet-opencl-icd
            sudo apt-get -y install ocl-icd-libopencl1
            sudo apt -y install /root/SoftInst/Plex/PlexARMv8.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            sudo systemctl enable plexmediaserver
            sudo systemctl start plexmediaserver

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

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor Plex para Debian 12 (Bookworm)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor Plex para Debian 11 (Bullseye)..."
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  El paquete dialog no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install dialog
       echo ""
     fi

  menu=(dialog --checklist "Elección de la arquitectura:" 22 76 16)
    opciones=(
      1 "Instalar o actualizar versión x86 de 32 bits" off
      2 "Instalar o actualizar versión x86 de 64 bits" off
      3 "Instalar o actualizar versión ARMv7"          off
      4 "Instalar o actualizar versión ARMv8"          off
      5 "Cambiar la carpeta por defecto de Plex"       off
    )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices

        do

          case $choice in

          1)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura x86 de 32 bits...${cFinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/Plex32x86.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/Plex32x86.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            dpkg -i /root/SoftInst/Plex/Plex32x86.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            service plexmediaserver start

          ;;

          2)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura x86 de 64 bits...${cFinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/Plex64x86.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/Plex64x86.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            apt -y install /root/SoftInst/Plex/Plex64x86.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            service plexmediaserver start

          ;;

          3)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura ARMv7 (armhf)...${cFinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/PlexARMv7.deb

            echo ""
            echo "Descargando el paquete de instalación..."
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/PlexARMv7.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            dpkg -i /root/SoftInst/Plex/PlexARMv7.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            service plexmediaserver start

          ;;

          4)

            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura ARMv7 (arm64)...${cFinColor}"
            echo ""
            mkdir /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/PlexARMv8.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/PlexARMv8.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            apt-get -y install beignet-opencl-icd ocl-icd-libopencl1
            dpkg -i /root/SoftInst/Plex/PlexARMv8.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
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

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor Plex para Debian 10 (Buster)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor Plex para Debian 9 (Stretch)..."
  echo ""

  cColorVerde="\033[1;32m"
  cFinColor="\033[0m"

  menu=(dialog --timeout 5 --checklist "Elección de la arquitectura:" 22 76 16)
    opciones=(
      1 "Instalar o actualizar versión x86 de 32 bits" off
      2 "Instalar o actualizar versión x86 de 64 bits" off
      3 "Instalar o actualizar versión ARMv7" off
      4 "Instalar o actualizar versión ARMv8" off
    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)
            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura x86 de 32 bits...${cFinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/Plex32x86.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/Plex32x86.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            dpkg -i /root/SoftInst/Plex/Plex32x86.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            service plexmediaserver start
          ;;

          2)
            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura x86 de 64 bits...${cFinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/Plex64x86.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/Plex64x86.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            dpkg -i /root/SoftInst/Plex/Plex64x86.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            service plexmediaserver start
          ;;

          3)
            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura ARMv7 (armhf)...${cFinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/PlexARMv7.deb

            echo ""
            echo "Descargando el paquete de instalación..."
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/PlexARMv7.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            dpkg -i /root/SoftInst/Plex/PlexARMv7.deb

            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            service plexmediaserver start
          ;;

          4)
            echo ""
            echo -e "${cColorVerde}  Instalando Plex para arquitectura ARMv7 (arm64)...${cFinColor}"
            echo ""
            mkdir -p /root/SoftInst/Plex/ 2> /dev/null
            cd /root/SoftInst/Plex/
            rm -f /root/SoftInst/Plex/PlexARMv8.deb

            echo ""
            echo -e "${cColorVerde}  Descargando el paquete de instalación...${cFinColor}"
            echo ""
            wget http://hacks4geeks.com/_/premium/descargas/Debian/root/SoftInst/Plex/PlexARMv8.deb

            echo ""
            echo -e "${cColorVerde}  Deteniendo el servicio plexmediaserver (si es que está activo)...${cFinColor}"
            echo ""
            service plexmediaserver stop

            echo ""
            echo -e "${cColorVerde}  Instalando el paquete...${cFinColor}"
            echo ""
            dpkg -i /root/SoftInst/Plex/PlexARMv8.deb
          
            echo ""
            echo -e "${cColorVerde}  Arrancando el servicio plexediaserver...${cFinColor}"
            echo ""
            service plexmediaserver start
          ;;

        esac

  done

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor Plex para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor Plex para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi
