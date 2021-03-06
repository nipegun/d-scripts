#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------
#  Script de NiPeGun para dejar sólo el último kernel estable en los repositorios de Debian 9
#----------------------------------------------------------------------------------------------

ColorMensajes='\033[1;34m'
FinColor='\033[0m'

echo ""
echo -e "  ${ColorMensajes}Borrando todos los Kernels...${FinColor}"
echo ""
apt-get -y purge linux-image* linux-headers* linux-support*

echo ""
echo -e "  ${ColorMensajes}Borrando paquetes no utilizados...${FinColor}"
echo ""
apt-get -y autoremove

echo ""
echo -e "  ${ColorMensajes}Actualizando la lista de paquetes disponibles en los repositorios...${FinColor}"
echo ""
apt-get -y update

echo ""
echo -e "  ${ColorMensajes}Borrando /boot/* ...${FinColor}"
echo ""
rm -f /boot/*

echo ""
echo -e "  ${ColorMensajes}Instalando el último kernel...${FinColor}"
echo ""
apt-get -y install linux-image-amd64

VersUltKern=$(ls /boot | grep vmlinuz | awk -F'z-' '{print $2}')

echo ""
echo -e "  ${ColorMensajes}Actualizando el nuevo initrd (si existe)...${FinColor}"
echo ""
update-initramfs -v -u -t -k $VersUltKern

echo ""
echo -e "  ${ColorMensajes}Creando el nuevo initrd (si no existe)...${FinColor}"
echo ""
update-initramfs -v -c -t -k $VersUltKern

echo ""
echo -e "  ${ColorMensajes}Re-instalando grub...${FinColor}"
echo ""
grub-install --recheck /dev/sda

echo ""
echo -e "  ${ColorMensajes}Actualizando la configuración de grub...${FinColor}"
echo ""
update-grub

