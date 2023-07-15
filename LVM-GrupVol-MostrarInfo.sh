#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para mostrar info de los grupos de volúmenes LVM
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/LVM-GrupVol-MostrarInfo.sh | bash
# ----------

echo ""
echo "  Mostrando info de grupos de volúmenes..."
echo ""
vgs
echo ""

echo ""
echo "  Mostrando info de grupos de volúmenes (más completo)..."
echo ""
vgdisplay
echo ""

