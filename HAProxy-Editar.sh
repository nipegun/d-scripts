#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------
#  Script de NiPeGun para editar la configuración de HAProxy
#-------------------------------------------------------------

echo ""
echo "  Editando el archivo de configuración de HAProxy..."
echo ""
nano /etc/haproxy/haproxy.cfg

echo ""
echo "  Re-arrancando el servicio HAProxy..."
echo ""
service haproxy reload

echo ""
echo "  Estado del servicio:"
echo ""
service haproxy status

