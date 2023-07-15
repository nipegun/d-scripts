#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para borrar todos los archivos basura del sistema
# ----------

/root/scripts/d-scripts/Archivos-Borrar-DSStore.sh
/root/scripts/d-scripts/Archivos-Borrar-PuntoGuiónBajo.sh
/root/scripts/d-scripts/Archivos-Borrar-ZoneIdentifier.sh

echo ""
echo "  Borrando todas las papeleras de reciclaje..."
echo ""
find / -type d -name ".Trash-*" -print -exec rm -rf {} \;

