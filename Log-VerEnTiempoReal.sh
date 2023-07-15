#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para ver logs en tiempo real
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
    echo -e "$0 ${cColorVerde}[UbicaciónDelArchivoDeLog]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo ' $0 /var/logs/apache.log'
    
    echo ""
    exit
  else
    echo ""
    echo -e "${cColorVerde}Mostrando el archivo $1 en tiempo real, según se va modificando ...${cFinColor}"
    echo ""
    tailf $1
fi

