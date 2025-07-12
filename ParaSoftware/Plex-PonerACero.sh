#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar todo el contenido del servidor Plex y ponerlo a cero
# ----------

echo ""
echo "  Deteniendo el servidor Plex..."echo ""
service plexmediaserver stop

echo ""
echo "  Borrando el contenido del servidor..."echo ""
rm -rf "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server"

echo ""
echo "  Re-arrancando el servidor Plex..."echo ""
service plexmediaserver start

