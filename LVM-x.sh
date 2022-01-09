#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------
#  Script de NiPeGun para mostrar info de los volúmenes LVM
#------------------------------------------------------------

echo ""
echo "  Mostrando info de volúmenes físicos en el sistema..."
echo ""
pvs
echo ""

echo ""
echo "  Mostrando info de volúmenes físicos en el sistema..."
echo ""
pvdisplay
echo ""

echo ""
echo "  Mostrando info de grupos de volúmenes..."
echo ""
vgs
echo ""

echo ""
echo "  Mostrando info de grupos de volúmenes..."
echo ""
vgdisplay
echo ""

echo ""
echo "  Mostrando info de volúmenes lógicos del sistema..."
echo ""
lvs
echo ""

echo ""
echo "  Mostrando info de volúmenes lógicos del sistema (más completo)..."
echo ""
lvdisplay
echo ""

