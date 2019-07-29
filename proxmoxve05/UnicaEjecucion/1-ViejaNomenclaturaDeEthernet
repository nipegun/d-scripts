#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para volver los nombres de las interfaces ethernet a la nomenclatura vieja usada en ProxmoxVE 4 
#---------------------------------------------------------------------------------------------------------------------

sed -i -e 's|GRUB_TIMEOUT="5"|GRUB_TIMEOUT="1"|g' /etc/default/grub
sed -i -e 's|GRUB_CMDLINE_LINUX=""|GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"|g' /etc/default/grub
update-grub
echo "auto lo" > /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "iface eth0 inet manual" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "auto vmbr0" >> /etc/network/interfaces
echo "iface vmbr0 inet static" >> /etc/network/interfaces
echo "  address 192.168.0.10" >> /etc/network/interfaces
echo "  netmask 255.255.255.0" >> /etc/network/interfaces
echo "  gateway 192.168.0.1" >> /etc/network/interfaces
echo "  bridge_ports eth0" >> /etc/network/interfaces
echo "  bridge_stp off" >> /etc/network/interfaces
echo "  bridge_fd 0" >> /etc/network/interfaces
shutdown -r now

