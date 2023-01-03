#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para buscar archivos en una ubicación dada y cambiarles el año de la fecha de creación y modificación
# ----------

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 ruta año"
    echo ""
    echo "Ejemplo:"
    echo "&0 /home/nico/fotos/ 2015"
    echo "##################################################"
    echo ""
    exit $E_BADARGS
  else
    echo ""
    find $1 -type f -print0 | while read -d $'\0' vArchivo
      do
        vA=$(stat -c %y "$vArchivo" | cut -d '-' -f1)
        vM=$(stat -c %y "$vArchivo" | cut -d '-' -f2)
        vD=$(stat -c %y "$vArchivo" | cut -d '-' -f3 | cut -d ' ' -f1)
        vh=$(stat -c %y "$vArchivo" | cut -d ' ' -f2 | cut -d ':' -f1)
        vm=$(stat -c %y "$vArchivo" | cut -d ' ' -f2 | cut -d ':' -f2)
        vs=$(stat -c %y "$vArchivo" | cut -d ' ' -f2 | cut -d ':' -f3 | cut -d '.' -f1)
        touch -a -m -t "$2$vM$vD$vh$vm.$vs" "$vArchivo"
        #echo "Año $vA Mes $vM Día $vD Hora $vh Minuto $vm Segundo $vs"
      done
    echo ""
fi
