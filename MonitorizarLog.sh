#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ------------
#  SCRIPT DE NIPEGUN PARA MONITORIZAR LOGS
# ------------

EXPECTED_ARGS=2


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 CantidadDeLineas UbicaciónDelLog"
    echo ""
    echo "Ejemplo:"
    echo " $0 15 /var/log/kern.log"
    echo "------------------------------------------------------------------"
    echo ""
    exit $E_BADARGS
  else
    watch tail -n $1 $2
fi

