#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -----------
#  SCRIPT DE NIPEGUN PARA MOSTRAR SI EL SISTEMA
#  CUENTA CON SOPORTE PARA INTERRUPT REMAPPING
# -----------

# Ver si existe alguna línea con ecap en dmesg
# Si no existe no hay soporte para IR
if [ $(dmesg | grep ecap | wc -l) -eq 0 ]; then
  echo ""
  echo "  No se encontró soporte para interrupt remapping"
  echo ""
  exit 1
fi

# Si existe la línea con ecap
#
for i in $(dmesg | grep ecap | awk '{print $NF}'); do
  if [ $(( (0x$i & 0xf) >> 3 )) -ne 1 ]; then
    echo ""
    echo "  Interrupt remapping no está disponible"
    echo ""
    exit 1
  fi
done

# Obtener el ecap y asignarlo a una variable
Ecap=$(dmesg | grep ecap | awk '{print $NF}')

# Obtener el último caracter del ecap y asignarlo a otra variable
UltCarEcap=${Ecap: -1}

# Si el último caracter de la variable es 8, 9, a, b, c, d, e, o f
# Interrupt remapping está soportado.
if [ "$UltCarEcap" = "8" ] || [ "$UltCarEcap" = "9" ] || [ "$UltCarEcap" = "a" ] || [ "$UltCarEcap" = "b" ] || [ "$UltCarEcap" = "c" ] $
  then
    echo ""
    echo "  El sistema cuenta con soporte para Interrupt Remapping"
    echo ""
fi

