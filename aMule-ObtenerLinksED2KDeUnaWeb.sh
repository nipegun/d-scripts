#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para obtener los link E2DK desde el código fuente
#  de una Web cuya dirección conocemos
# ----------

cCantArgumEsperados=1

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""

    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "ObtenerLinksED2KDeLaWeb ${cColorVerde}[URLDeLaWeb]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' ObtenerLinksED2KDeLaWeb http://descargas.com/series/xfiles.php'
    echo ""
    exit
  else
    echo ""
    curl $1 | grep ed2k | grep href > /links.txt
    sed -i -e 's|"ed2k|\ned2k|g' /links.txt
    sed -i -e 's|" class=|\n\n|g' /links.txt
    cat /links.txt | grep ed2k | grep -v href
    rm -f /links.txt
    echo ""
fi
