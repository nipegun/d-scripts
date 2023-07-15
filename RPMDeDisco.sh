#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -----------
#  Script de NiPeGun para saber las RPMs de un disco duro
# -----------

EXPECTED_ARGS=1


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 Dispositivo"
    echo ""
    echo "Ejemplo:"
    echo " $0 /dev/sdb"
    
    echo ""
    exit $E_BADARGS
  else
    smartctl --all $1 | grep Rotation
fi

