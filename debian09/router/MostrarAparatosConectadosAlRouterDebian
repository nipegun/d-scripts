#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar los aparatos conectados al router debian corriendo en el ordenador donde se ejecuta este script
#----------------------------------------------------------------------------------------------------------------------------------

# Asignar a una variable el nombre de la interfaz en la que se routea obtenido del archivo correspondiente
interfaz=$(sed -n 's|INTERFACESv4="\(.*\)"|\1|p' /etc/default/isc-dhcp-server)

echo ""
echo "--------------------------------------------------"
echo "  Mostrando aparatos conectados al router Debian"
echo "  que corre en este ordenador..."
echo "---------------------------------------------------"
echo ""
arp-scan --interface=$interfaz --localnet

