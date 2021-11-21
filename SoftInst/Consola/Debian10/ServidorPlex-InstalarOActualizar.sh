#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar el servidor Plex
#-----------------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

apt-get -y update 2> /dev/null
apt-get -y install dialog 2> /dev/null

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
          mkdir -p /root/SoftInst/Plex/
          cd /root/SoftInst/Plex/
          rm -f /root/SoftInst/Plex/plex32x86.deb

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
          wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/plex/plex64x86.deb

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
          wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/plex/plexARMv7.deb

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
          wget http://hacks4geeks.com/_/premium/descargas/Debian/root/paquetes/plex/plexARMv8.deb

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

      esac

done

