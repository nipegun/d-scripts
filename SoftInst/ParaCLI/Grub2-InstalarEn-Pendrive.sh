#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar grub2 en un pendrive
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Grub2-InstalarEn-Pendrive.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Grub2-InstalarEn-Pendrive.sh | bash
#
# Ejecución remota con parámetros:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Grub2-InstalarEn-Pendrive.sh | bash -s Parámetro
# ----------

vDisposPen="/dev/sdb"

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi

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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de grub2 en pendrive desde Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de grub2 en pendrive desde Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de grub2 en pendrive desde Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de grub2 en pendrive desde Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de grub2 en pendrive desde Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Comprobar si el paquete grub2 está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s grub2 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  grub2 no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install grub2
      echo ""
    fi

  echo ""
  echo "  Creando la carpeta para montar el pendrive..." 
echo ""
  mkdir -p /Particiones/USB/PendriveGrub2/ 2> /dev/null

  echo ""
  echo "  Montando la primera partición del pendrive en /Particiones/USB/PendriveGrub2/..." 
echo ""
  umount "$vDisposPen"1
  mount -t auto "$vDisposPen"1 /Particiones/USB/PendriveGrub2/

  echo ""
  echo "  Borrando archivos viejos de instalaciones anteriores..." 
echo ""
  rm -rf /Particiones/USB/PendriveGrub2/boot

  echo ""
  echo "  Indicando que /dev/sda sea el primer disco..." 
echo ""
  mkdir -p /Particiones/USB/PendriveGrub2/boot/grub/
  echo "(hd0) /dev/sda"  > /Particiones/USB/PendriveGrub2/boot/grub/device.map
  echo "(hd1) /dev/sdb" >> /Particiones/USB/PendriveGrub2/boot/grub/device.map
  echo "(hd2) /dev/sdc" >> /Particiones/USB/PendriveGrub2/boot/grub/device.map
  echo "(hd3) /dev/sdd" >> /Particiones/USB/PendriveGrub2/boot/grub/device.map
  echo "(hd4) /dev/sde" >> /Particiones/USB/PendriveGrub2/boot/grub/device.map
  
  echo ""
  echo "  Instalando grub2 para MBR en $vDisposPen..." 
echo ""
  mkdir -p /Particiones/USB/PendriveGrub2/boot/
  grub-install $vDisposPen --debug --target=i386-pc --boot-directory=/Particiones/USB/PendriveGrub2/boot

  echo ""
  echo "  Instalando grub2 para EFI en $vDisposPen..." 
echo ""
  mkdir -p /Particiones/USB/PendriveGrub2/
  # Comprobar si el paquete efibootmgr está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s efibootmgr 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  efibootmgr no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install efibootmgr
      echo ""
    fi
  grub-install $vDisposPen --debug --target=x86_64-efi --efi-directory=/Particiones/USB/PendriveGrub2 --bootloader-id=GRUB --removable

  echo ""
  echo "  Creando el archivo grub.cfg..." 
echo ""
  grub-mkconfig -o /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  cp /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg.bak
  echo 'if [ ${grub_platform} == "pc" ]; then'                                       > /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  submenu 'Bootear particiones con Windows' {"                              >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'Windows XP' {"                                               >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod part_msdos"                                                    >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod ntfs"                                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod ntldr"                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      search --no-floppy --set=root --file /ntldr"                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      ntldr /ntldr"                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'Windows Vista/7/8/8.1/10/11' {"                              >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod part_msdos"                                                    >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod ntfs"                                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod ntldr"                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      search --no-floppy --set=root --file /bootmgr"                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      ntldr /bootmgr"                                                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  submenu 'Bootear particiones con Debian' {"                               >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'Autodetectar Debian e iniciarlo' {"                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      echo 'Autodetectando e iniciando Debian...'"                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod part_msdos"                                                    >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod ext2"                                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      search --no-floppy --set=root --file /vmlinuz --hint-bios=hd0,msdos1" >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo '      set dispo=set grub-probe --target=device /'                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo '      echo $dispo'                                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo '      linux  /vmlinuz root=${root} ro net.ifnames=0 biosdevname=0 quiet'    >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      initrd /initrd.img"                                                   >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'Debian en /dev/sda3'{"                                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      echo 'Iniciando el Debian instalado en /dev/sda3...'"                 >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod part_msdos"                                                    >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod ext2"                                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      set root='hd1,msdos3'"                                                >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      linux  /vmlinuz root=/dev/sda3 ro net.ifnames=0 biosdevname=0 quiet"  >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      initrd /initrd.img"                                                   >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  submenu 'Bootear particiones con Ubuntu' {"                               >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'Ubuntu en /dev/sda4'{"                                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      echo 'Iniciando el Debian instalado en /dev/sda4...'"                 >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod part_msdos"                                                    >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod ext2"                                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      set root='hd1,msdos4'"                                                >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      linux   /boot/vmlinuz root=/dev/sda4 ro quiet"                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      initrd  /boot/initrd.img"                                             >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  menuentry 'Reiniciar el sistema' {"                                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    echo 'Reiniciando el sistema...'"                                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    reboot"                                                                 >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  menuentry 'Apagar el sistema' {"                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    echo 'Apagando el sistema...'"                                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    halt"                                                                   >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  menuentry 'Configuración UEFI' {"                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    fwsetup"                                                                >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfgecho "fi"                                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo 'if [ ${grub_platform} == "efi" ]; then'                                     >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  menuentry 'Configuración UEFI' {"                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    fwsetup"                                                                >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  submenu 'Lanzar bootloaders EFI para Windows' {"                          >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'Microsoft Windows Vista/7/8/8.1/10/11' {"                    >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod part_gpt"                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod fat"                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod search_fs_uuid"                                                >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod chain"                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo '      search --fs-uuid --set=root $hints_string $fs_uuid'                   >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      chainloader /EFI/Microsoft/Boot/bootmgfw.efi"                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  submenu 'Lanzar bootloaders EFI para Debian' {"                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'BootLoader GrubX64' {"                                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod fat"                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod chain"                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      search --no-floppy --set=root --file /EFI/Debian/grubx64.efi"         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      chainloader /EFI/Debian/grubx64.efi"                                  >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  submenu 'Lanzar bootloaders EFI para Ubuntu' {"                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'BootLoader GrubX64' {"                                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod fat"                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod chain"                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      search --no-floppy --set=root --file /EFI/Ubuntu/grubx64.efi"         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      chainloader /EFI/Ubuntu/grubx64.efi"                                  >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  submenu 'Lanzar bootloaders EFI para Hackintosh' {"                       >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    menuentry 'BootLoader OpenCore' {"                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod fat"                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      insmod chain"                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      search --no-floppy --set=root --file /EFI/OpenCore/opencore.efi"      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "      chainloader /EFI/OpenCore/opencore.efi"                               >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "    }"                                                                      >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "  }"                                                                        >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo "fi"                                                                         >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg
  echo ""                                                                           >> /Particiones/USB/PendriveGrub2/boot/grub/grub.cfg

fi

