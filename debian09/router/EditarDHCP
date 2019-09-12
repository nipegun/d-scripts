#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------
#  Script de NiPeGun para editar la configuración del demonio dhcpd
#--------------------------------------------------------------------

echo ""
echo "  Editando la configuración de DHCP..."
echo ""
nano /etc/dhcp/dhcpd.conf

echo ""
echo "  Reiniciando el servicio isc-dhcp-server..."
echo ""
service isc-dhcp-server restart

echo ""
echo "  Mostrando el estado del servicio isc-dhcp-server..."
echo ""
sleep 5
service isc-dhcp-server status

