#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------
#  Script de NiPeGun para editar la configuración de HAProxy
#-------------------------------------------------------------

echo ""
echo "  Deteniendo el servicio mumble-server..."
echo ""
service mumble-server stop

echo ""
echo "  Editando el archivo de configuración de mumble-server..."
echo ""
nano /etc/mumble-server.ini

echo ""
echo "  Re-arrancando el servicio mumble-server..."
echo ""
service mumble-server start

echo ""
echo "  Estado del servicio:"
echo ""
service mumble-server status

