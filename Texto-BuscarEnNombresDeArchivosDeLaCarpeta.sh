#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para buscar una cadena específica dentro de los nombres de archivos de una carpeta específica
# ----------

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: btenda ruta texto"
    echo ""
    echo "Ejemplo:"
    echo "btenda /etc/ Perro"
    echo "##################################################"
    echo ""
    exit $E_BADARGS
  else
    echo ""
    find $1 -type f -name "*$2*" -print
    echo ""
fi

