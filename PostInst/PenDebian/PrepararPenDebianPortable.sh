#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para preparar el Pendrive de Debian Portable
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/PenDebian/PrepararPenDebianPortable.sh | bash
#---------------------------------------------------------------------------------------------------------------------------

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
  echo "Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 8 (Jessie) Portable..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 9 (Stretch) Portable..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 10 (Buster) Portable..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de preparación del Pendrive con Debian 11 (Bullseye) Portable..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  ## Modificar el grub
     sed -i -e 's|GRUB_TIMEOUT=5|GRUB_TIMEOUT=1|g' /etc/default/grub
     sed -i -e 's|GRUB_CMDLINE_LINUX=""|GRUB_CMDLINE_LINUX="net.ifnames=0" biosdevname=0|g' /etc/default/grub
     update-grub

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

  ## Herramientas de terminal
     apt-get -y update
     apt-get -y install gparted
     apt-get -y install wget
     apt-get -y install curl
     apt-get -y install nmap
     apt-get -y install mc
     apt-get -y install smartmontools
     apt-get -y install coreutils
     apt-get -y install sshpass
     apt-get -y install unrar
     apt-get -y install android-tools-adb # Para poder operar con el contenido de los móviles y relojes android
     apt-get -y install android-tools-fastboot

  ## Herramientas gráficas
     apt-get -y install caja-open-terminal
     apt-get -y install caja-admin
     apt-get -y install vlc
     apt-get -y install vlc-plugin-vlsub
     apt-get -y install audacity
     apt-get -y install subtitleeditor
     apt-get -y install easytag
     apt-get -y install wireshark
     apt-get -y install etherape
     apt-get -y install thunderbird
     apt-get -y install thunderbird-l10n-es-es
     apt-get -y install lightning-l10n-es-es
     apt-get -y install eiskaltdcpp
     apt-get -y install amule
     apt-get -y install chromium
     apt-get -y install chromium-l10n
     apt-get -y install filezilla
     apt-get -y install htop
     apt-get -y install simple-scan
     apt-get -y install ghex

  ## Antivirus
     apt-get -y install clamtk
     apt-get -y install clamav
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
     #ACCEPT_EULA=Y apt-get -y install firmware-ipw2x00
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

  ## Borrar paquetes
     apt-get -y remove xterm reportbug blender imagemagick inkscape gnome-disk-utility
     apt-get -y autoremove

  ## x 
     echo -n mem > /sys/power/state

  ## ComandosPostArranque
     curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/ComandosPostArranque-Preparar.sh | bash

  ## Cortafuegos
     curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/Cortafuegos-Preparar.sh | bash

  ## Tareas cron
     curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Consola/TareasCron-Preparar.sh | bash

  ## Agregar comandos post arranque
     echo "mount -t auto /dev/sda1 /Particiones/sda1/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sda2 /Particiones/sda2/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sda3 /Particiones/sda3/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sda4 /Particiones/sda4/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb1 /Particiones/sdb1/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb2 /Particiones/sdb2/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb3 /Particiones/sdb3/" >> /root/scripts/ComandosPostArranque.sh
     echo "mount -t auto /dev/sdb4 /Particiones/sdb4/" >> /root/scripts/ComandosPostArranque.sh

  ## Escritorio mate
     curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/Escritorio/EscritorioMate-Personalizar.sh| bash

  ## d-scripts
     curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/DScripts-Sincronizar.sh | bash

  ## Documentos
  
     mkdir -p /root/Documentos/ 2> /dev/null

     ## Chameleon desde Grub
         echo "gedit /boot/grub/grub.cfg"         > /root/Documentos/BootearChameleonDesdeGrub.txt
         echo ""                                 >> /root/Documentos/BootearChameleonDesdeGrub.txt
         echo 'menuentry "macOS" {'              >> /root/Documentos/BootearChameleonDesdeGrub.txt
         echo "  insmod hfsplus"                 >> /root/Documentos/BootearChameleonDesdeGrub.txt
         echo "  search --file --set=root /boot" >> /root/Documentos/BootearChameleonDesdeGrub.txt
         echo "  multiboot /boot"                >> /root/Documentos/BootearChameleonDesdeGrub.txt
         echo "}"                                >> /root/Documentos/BootearChameleonDesdeGrub.txt

      ## Actualizar ClamTK
         echo '#!/bin/bash' > /root/Documentos/ActualizarClamAV.txt
         echo "freshclam"  >> /root/Documentos/ActualizarClamAV.txt

      ## Borrar SSD
         echo '#!/bin/bash'                                                              > /root/Documentos/BorrarSSD.txt
         echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
         echo "# Cerrar la tapa del portátil (para hibernar Linux) y volver a abrirla." >> /root/Documentos/BorrarSSD.txt
         echo "# Cuando rearranque ejecutar"                                            >> /root/Documentos/BorrarSSD.txt
         echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
         echo "hdparm -I /dev/sda | grep frozen"                                        >> /root/Documentos/BorrarSSD.txt
         echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
         echo "# BORRAR /dev/sda"                                                       >> /root/Documentos/BorrarSSD.txt
         echo "hdparm --user-master u --security-set-pass hacks4geeks /dev/sda"         >> /root/Documentos/BorrarSSD.txt
         echo "hdparm --user-master u --security-erase hacks4geeks /dev/sda"            >> /root/Documentos/BorrarSSD.txt
         echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
         echo "# BORRAR /dev/sdb"                                                       >> /root/Documentos/BorrarSSD.txt
         echo "hdparm --user-master u --security-set-pass hacks4geeks /dev/sdb"         >> /root/Documentos/BorrarSSD.txt
         echo "hdparm --user-master u --security-erase hacks4geeks /dev/sdb"            >> /root/Documentos/BorrarSSD.txt

fi
