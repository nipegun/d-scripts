#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------
#  Script de NiPeGun para preparar el Pendrive de Debian Portable
#
#  Ejecución remota:
#  curl -s | bash
#------------------------------------------------------------------

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
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 7 (Wheezy) Portable..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 8 (Jessie) Portable..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 9 (Stretch) Portable..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 10 (Buster) Portable..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 11 (Bullseye) Portable..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  ## Agregar repositorios
     cp /etc/apt/sources.list /etc/apt/sources.list.bak
     echo "deb http://deb.debian.org/debian bullseye main contrib non-free"                         > /etc/apt/sources.list
     echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free"                    >> /etc/apt/sources.list
     echo ""                                                                                       >> /etc/apt/sources.list
     echo "deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free"     >> /etc/apt/sources.list
     echo "deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list
     echo ""                                                                                       >> /etc/apt/sources.list
     echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free"                >> /etc/apt/sources.list
     echo "deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free"            >> /etc/apt/sources.list
     echo ""                                                                                       >> /etc/apt/sources.list

  ## Instalación de paquetes
     apt-get -y update
     apt-get -y install gparted
     apt-get -y install wget
     apt-get -y install curl
     apt-get -y install nmap
     apt-get -y install mc
     apt-get -y install smartmontools
     apt-get -y install coreutils

  ## Antivirus
     apt-get -y install clamtk
     apt-get -y install clamav-freshclam
     apt-get -y install clamav-daemon
     mkdir /var/log/clamav/ 2> /dev/null
     #touch /var/log/clamav/freshclam.log
     #chown clamav:clamav /var/log/clamav/freshclam.log
     #chmod 640 /var/log/clamav/freshclam.log
     rm -rf /var/log/clamav/freshclam.log
     freshclam

  ## Instalación de firmwares
     apt-get -y install firmware-linux-free
     apt-get -y install firmware-ath9k-htc
     #apt-get -y install firmware-ath9k-htc-dbgsym
     apt-get -y install firmware-b43-installer
     apt-get -y install firmware-b43legacy-installer
     apt-get -y install atmel-firmware
     apt-get -y install bluez-firmware
     apt-get -y install firmware-amd-graphics
     apt-get -y install firmware-atheros
     apt-get -y install firmware-bnx2
     apt-get -y install firmware-bnx2x
     apt-get -y install firmware-brcm80211
     apt-get -y install firmware-cavium
     apt-get -y install firmware-intelwimax
     apt-get -y install firmware-ipw2x00
     apt-get -y install firmware-iwlwifi
     apt-get -y install firmware-linux
     apt-get -y install firmware-linux-nonfree
     apt-get -y install firmware-misc-nonfree
     apt-get -y install firmware-myricom
     apt-get -y install firmware-netronome
     apt-get -y install firmware-netxen
     apt-get -y install firmware-qcom-media
     apt-get -y install firmware-ralink
     apt-get -y install firmware-realtek
     apt-get -y install firmware-ti-connectivity
     apt-get -y install firmware-zd1211

  ## Otros cambios
     mkdir -p /Discos/LVM/  2> /dev/null
     mkdir -p /Discos/SATA/ 2> /dev/null
     mkdir -p /Discos/NVMe/ 2> /dev/null
     mkdir -p /Particiones/Windows/ 2> /dev/null
     mkdir -p /Particiones/macOS/   2> /dev/null
     mkdir -p /Particiones/sda1/    2> /dev/null
     mkdir -p /Particiones/sda2/    2> /dev/null
     mkdir -p /Particiones/sda3/    2> /dev/null
     mkdir -p /Particiones/sda4/    2> /dev/null
     mkdir -p /Particiones/sdb1/    2> /dev/null
     mkdir -p /Particiones/sdb2/    2> /dev/null
     mkdir -p /Particiones/sdb3/    2> /dev/null
     mkdir -p /Particiones/sdb4/    2> /dev/null

  ## Actualizar el sistema
     apt-get -y upgrade
     apt-get -y dist-upgrade

  ## x 
     echo -n mem > /sys/power/state

  ## ComandosPostArranque
     echo ""
     echo -e "${ColorVerde}Configurando el servicio...${FinColor}"
     echo ""
     echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
     echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
     echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
     echo ""                                        >> /etc/systemd/system/rc-local.service
     echo "[Service]"                               >> /etc/systemd/system/rc-local.service
     echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
     echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
     echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
     echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
     echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
     echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
     echo ""                                        >> /etc/systemd/system/rc-local.service
     echo "[Install]"                               >> /etc/systemd/system/rc-local.service
     echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service
     echo ""
     echo -e "${ColorVerde}Creando el archivo /etc/rc.local ...${FinColor}"
     echo ""
     echo '#!/bin/bash'                            > /etc/rc.local
     echo ""                                      >> /etc/rc.local
     echo "/root/scripts/ComandosPostArranque.sh" >> /etc/rc.local
     echo "exit 0"                                >> /etc/rc.local
     chmod +x                                        /etc/rc.local
     echo ""
     echo -e "${ColorVerde}Creando el archivo para meter los comandos...${FinColor}"
     echo ""
     mkdir -p /root/scripts/ 2> /dev/null
     echo '#!/bin/bash'                                                                                         > /root/scripts/ComandosPostArranque.sh
     echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
     echo "ColorRojo='\033[1;31m'"                                                                             >> /root/scripts/ComandosPostArranque.sh
     echo "ColorVerde='\033[1;32m'"                                                                            >> /root/scripts/ComandosPostArranque.sh
     echo "FinColor='\033[0m'"                                                                                 >> /root/scripts/ComandosPostArranque.sh
     echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
     echo 'FechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ComandosPostArranque.sh
     echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
     echo 'echo "Iniciada la ejecución del script post-arranque el $FechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ComandosPostArranque.sh
     echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
     echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                    >> /root/scripts/ComandosPostArranque.sh
     echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                  >> /root/scripts/ComandosPostArranque.sh
     echo ""                                                                                                   >> /root/scripts/ComandosPostArranque.sh
     chmod 700                                                                                                    /root/scripts/ComandosPostArranque.sh
     echo ""
     echo -e "${ColorVerde}Activando y arrancando el servicio...${FinColor}"
     echo ""
     systemctl enable rc-local
     systemctl start rc-local.service

  ## Agregar comandos post arranque
     echo "mount -t auto /dev/sda1 /Particiones/sda1/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sda2 /Particiones/sda2/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sda3 /Particiones/sda3/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sda4 /Particiones/sda4/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb1 /Particiones/sdb1/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb2 /Particiones/sdb2/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb3 /Particiones/sdb3/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb4 /Particiones/sdb4/" >> /root/scripts/ComandosPostArranque.sh

  ## Documentos
  
     mkdir -p /root/Documents/ 2> /dev/null

     ## Chameleon desde Grub
         echo "gedit /boot/grub/grub.cfg"         > /root/Documents/BootearChameleonDesdeGrub.txt
         echo ""                                 >> /root/Documents/BootearChameleonDesdeGrub.txt
         echo 'menuentry "macOS" {'              >> /root/Documents/BootearChameleonDesdeGrub.txt
         echo "  insmod hfsplus"                 >> /root/Documents/BootearChameleonDesdeGrub.txt
         echo "  search --file --set=root /boot" >> /root/Documents/BootearChameleonDesdeGrub.txt
         echo "  multiboot /boot"                >> /root/Documents/BootearChameleonDesdeGrub.txt
         echo "}"                                >> /root/Documents/BootearChameleonDesdeGrub.txt

      ## Actualizar ClamTK
         echo '#!/bin/bash' > /root/Documents/ActualizarClamAV.txt
         echo "freshclam"  >> /root/Documents/ActualizarClamAV.txt

      ## Borrar SSD
         echo '#!/bin/bash'                                                              > /root/Documents/BorrarSSD.txt
         echo ""                                                                        >> /root/Documents/BorrarSSD.txt
         echo "# Cerrar la tapa del portátil (para hibernar Linux) y volver a abrirla." >> /root/Documents/BorrarSSD.txt
         echo "# Cuando rearranque ejecutar"                                            >> /root/Documents/BorrarSSD.txt
         echo ""                                                                        >> /root/Documents/BorrarSSD.txt
         echo "hdparm -I /dev/sda | grep frozen"                                        >> /root/Documents/BorrarSSD.txt
         echo ""                                                                        >> /root/Documents/BorrarSSD.txt
         echo "# BORRAR /dev/sda"                                                       >> /root/Documents/BorrarSSD.txt
         echo "hdparm --user-master u --security-set-pass hacks4geeks /dev/sda"         >> /root/Documents/BorrarSSD.txt
         echo "hdparm --user-master u --security-erase hacks4geeks /dev/sda"            >> /root/Documents/BorrarSSD.txt
         echo ""                                                                        >> /root/Documents/BorrarSSD.txt
         echo "# BORRAR /dev/sdb"                                                       >> /root/Documents/BorrarSSD.txt
         echo "hdparm --user-master u --security-set-pass hacks4geeks /dev/sdb"         >> /root/Documents/BorrarSSD.txt
         echo "hdparm --user-master u --security-erase hacks4geeks /dev/sdb"            >> /root/Documents/BorrarSSD.txt
         
fi
