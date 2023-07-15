#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para administrar usuarios del servidor Calibre
# ----------

echo ""
echo "--------------------------------------------"
echo "  Deteniendo el servicio calibre-server..."echo "--------------------------------------------"
systemctl stop calibre-server

echo ""
echo "--------------------------------------------------"
echo "  Administrando usuarios del servidor Calibre..."echo "--------------------------------------------------"
echo ""
echo "Acciones:"
calibre-server --manage-users

echo ""
echo "-----------------------------------------------"
echo "  Re-arrancando el servicio calibre-srever..."echo "-----------------------------------------------"
echo ""
systemctl start calibre-server

