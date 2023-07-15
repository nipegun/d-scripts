#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner a cero todos los logs de todas las web en /var/www
# ----------

echo ""
echo "  BORRANDO LOS ARCHIVOS access.log DE TODO /var/www y sub-directorios..."
echo ""
find /var/www/ -type f -name "access.log" -print -exec truncate -s 0 {} \;
echo ""

echo ""
echo "  BORRANDO LOS ARCHIVOS error.log DE TODO /var/www y sub-directorios..."
echo ""
find /var/www/ -type f -name "error.log" -print -exec truncate -s 0 {} \;
echo ""

