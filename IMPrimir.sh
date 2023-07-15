#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para Imprimir un texto desde la terminal en Debian 9
# ----------

cColorRojo="\033[1;31m"
cColorVerde="\033[1;32m"
cFinColor="\033[0m"

cCantArgumEsperados=2


if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}Mal uso del script!${cFinColor}"
    echo ""
    echo -e 'El uso correcto sería: '$0' '${cColorVerde}'["Texto"] [ImpresoraDestino]'${cFinColor}''
    echo ""
    echo "Ejemplo:"
    echo ""
    echo ''$0' "Me la pela el lorem ipsum" Officejet7610'
    echo ""
    exit
  else
    echo ""
    echo "Mandando la tarea a la cola de impresión..."
    echo ""
    echo $1 | lp -d $2
    echo ""
fi

