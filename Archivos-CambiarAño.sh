#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el año de todos los archivos dentro de una carpeta dada
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Archivos-CambiarA%C3%B1o.sh | bash
# ----------

vCarpeta="$1"
vAño="$2"
vFechaDeseada=201701011010.10

for vArchivo in "$vCarpeta"
  do
    # Obtener mes del archivo
      #vMes=$($vArchivo)
      #echo "  El mes es: $vMes"
    # Obtener hora del archivo
      #vHora=$($vArchivo)
      #echo "  La hora es: $vHora"
    # Obtener minuto del archivo
      #vMin=$($vArchivo)
      #echo "  El minuto es: $vMin"
    # Obtener segundo del archivo
      #vSeg=$($vArchivo)
      #echo "  El segundo es: $vSeg"
    # Aplicar cambio de año
      #touch -t $vAño$vMes$vHora$vMin$vSeg $vArchivo
      date -r $vArchivo "+%m-%d-%Y %H:%M:%S"

  done
#touch --date=2015-09-01
#find $vCarpeta -type d -print -exec touch -t $vFechaDeseada {} \;
#find $vCarpeta -type f -print -exec touch -t $vFechaDeseada {} \;

