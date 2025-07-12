#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para comprobar las nuevas pelis geek
#  disponibles para descargar en YTS
# ----------
# ----------
# Script de NiPeGun para BLOQUEAR UN MÓDULO ESPECÍFICO
# ----------

cCantArgumEsperados=1


if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [NombreDelMódulo]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 igb'
    
    echo ""
    exit
  else
    
    curl https://yts.am/browse-movies/0/all/sci-fi/0/latest | grep movie/ | grep link
    echo ""
fi


