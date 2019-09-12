#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar los aparatos conectados a la misma red a la que está conectada la interfaz indicada
#----------------------------------------------------------------------------------------------------------------------

CantArgsCorrectos=1
ArgsInsuficientes=65

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [Interfaz]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 eth0'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo "---------------------------------------------------"
    echo "  Mostrando aparatos conectados a la red a la que"
    echo "  está conectada la interfaz $1..."
    echo "---------------------------------------------------"
    echo ""
    arp-scan --interface=$1 --localnet
fi

