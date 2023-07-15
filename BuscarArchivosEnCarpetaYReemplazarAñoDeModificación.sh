#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para buscar archivos en una ubicación dada y cambiarles el año de la fecha de creación y modificación
# ----------

cCantArgumEsperados=2


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 Carpeta AñoAPoner"
    echo ""
    echo "Ejemplo:"
    echo "&0 /home/nico/fotos/ 2015"
    echo "##################################################"
    echo ""
    exit
  else
    echo ""
    find $1 -type f -print0 | while read -d $'\0' vArchivo
      do
        # Obtener el número de año de modificación del archivo
          vA=$(stat -c %y "$vArchivo" | cut -d '-' -f1)
        # Obtener el número de mes de modificación del archivo
          vM=$(stat -c %y "$vArchivo" | cut -d '-' -f2)
        # Obtener el número de día de modificación del archivo
          vD=$(stat -c %y "$vArchivo" | cut -d '-' -f3 | cut -d ' ' -f1)
        # Obtener el número de hora de modificación del archivo
          vh=$(stat -c %y "$vArchivo" | cut -d ' ' -f2 | cut -d ':' -f1)
        # Obtener el número de minutos de modificación del archivo
          vm=$(stat -c %y "$vArchivo" | cut -d ' ' -f2 | cut -d ':' -f2)
        # Obtener el número de segundos de modificación del archivo
          vs=$(stat -c %y "$vArchivo" | cut -d ' ' -f2 | cut -d ':' -f3 | cut -d '.' -f1)
        # Cambiar la fecha de modificación del archivo al año indicado en el parámetro 2
          echo "Cambiando el año de modificación del archivo $vArchivo a $2..."
          touch -a -m -t "$2$vM$vD$vh$vm.$vs" "$vArchivo"
      done
    echo ""
fi

