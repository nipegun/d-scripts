#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -------------
#  Script de NiPeGun para calcular el ancho de banda teórico máximo a Google
#  via eduardocollado.com
#  TamañoDeVentanaTCPenBits/LatenciaEnSegundos=BitsPorSegundoDeTransferencia
# -------------


cCantArgsCorrectos=1


if [ $# -ne $cCantArgsCorrectos ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [Tamaño en KB]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 64'
    
    echo ""
    exit
  else
    echo ""
    echo "  Calculando la latencia del ping a google.com..."
    echo ""
    pinggoogle=$(ping -c 1 google.com | sed -ne '/.*time=/{;s///;s/\..*//;p;}')
    pingenseg=$(awk 'BEGIN { print ("'$pinggoogle'"/1000) }')
    echo "  El ping a google.com tiene una latencia de $pinggoogle ms, o lo que es lo mismo: $pingenseg seg"
    anchobandteorbps=$(awk 'BEGIN { print ("'$1'"*1024*8/"'$pingenseg'") }')
    echo ""
    anchobandteormbps=$(awk 'BEGIN { print ("'$anchobandteorbps'"/1000000) }')
    echo "  Para una ventana de $1 KB, el ancho de banda teórico máximo sería de: $anchobandteormbps Mbps"
    echo ""
fi
