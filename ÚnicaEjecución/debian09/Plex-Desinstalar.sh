#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------
#  Script de NiPeGun para desinstalar Plex de Debian 9, por completo
#---------------------------------------------------------------------

echo ""
echo "  Eliminando el paquete plexmediaserver"
echo ""
dpkg -r plexmediaserver

echo ""
echo "  Borrando la carpeta Plex Media Server..."
echo ""
rm -R /var/lib/plexmediaserver/

echo ""

