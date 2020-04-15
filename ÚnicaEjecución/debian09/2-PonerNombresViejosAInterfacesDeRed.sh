#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA RE-ESCRIBIR /etc/network/interfaces
#  CON LOS NOMBRES DE INTERFACES DE RED ANTIGUOS
#--------------------------------------------------------------

echo ""
echo "-----------------------------------------"
echo "  CONFIGURANDO LAS INTERFACES DE RED..."
echo "-----------------------------------------"
echo ""
echo "auto lo" > /etc/network/interfaces
echo "  iface lo inet loopback" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "auto eth0" >> /etc/network/interfaces
echo "  allow-hotplug eth0" >> /etc/network/interfaces
echo "  iface eth0 inet dhcp" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

