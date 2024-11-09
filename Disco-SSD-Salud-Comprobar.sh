#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para COMPROBAR SALUD DEL SSD
# ----------

cCantArgumEsperados=1


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 Dispositivo"
    echo ""
    echo "Ejemplo:"
    echo " $0 /dev/sda"
    
    echo ""
    exit
  else
    echo ""
    echo "  ACTIVANDO SMART EN EL DISPOSITIVO..."
    echo ""
    smartctl -s on $1

    echo ""
    echo "  OBTENIENDO INFORMACIÓN GENERAL..."
    echo ""
    smartctl -x $1

    echo ""
    echo "  CORRIENDO TEST CORTO..."
    echo ""
    #smartctl -t short $1
    
    echo ""
    echo "  CORRIENDO TEST LARGO..."
    echo ""
    #smartctl -t long $1
    
    echo ""
    echo "  COMPROBANDO RESULTADO DE LOS TESTS..."
    echo ""
    smartctl -l selftest $1

    echo ""
    echo "  ESTADO DE SALUD:"
    echo ""
    smartctl -H $1 | grep overall-health
    
    echo ""
    echo "  HORAS ENCENDIDO:"
    echo ""
    smartctl -x $1 | grep ATTRIBUTE_NAME 
    smartctl -x $1 | grep Power_On_Hours

    echo ""
    echo "  PORCENTAJE DE VIDA ÚTIL CONSUMIDO:"
    echo ""
    smartctl -x $1 | grep ATTRIBUTE_NAME 
    smartctl -x $1 | grep Percent_Lifetime_Used

    echo ""
    echo "  PORCENTAJE DE VIDA ÚTIL RESTANTE:"
    echo ""
    smartctl -x $1 | grep ATTRIBUTE_NAME
    smartctl -x $1 | grep Remaining_Lifetime_Perc
    
    echo ""
    echo "  :"
    echo ""
    smartctl -x $1 | grep ATTRIBUTE_NAME 
    smartctl -x $1 | grep Media_Wearout_Indicator
    
fi

