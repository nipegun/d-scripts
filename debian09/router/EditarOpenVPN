#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------
#  Script de NiPeGun para editar la configuración del demonio openvpn
#----------------------------------------------------------------------

echo ""
echo "  Deteniendo el servicio openvpn..."
echo ""
service openvpn stop

echo ""
echo "  Editando el archivo de configuración..."
echo ""
nano /etc/openvpn/server.conf

echo ""
echo "  Volviendo a iniciar el servicio openvpn..."
echo ""
service openvpn start

echo ""
echo "  Mostrando el estado del servicio openvpn..."
echo ""
sleep 5
service openvpn status

