#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------
#  Script de NiPeGun para Imprimir un archivo desde la terminal en Debian 9
#----------------------------------------------------------------------------

ColorAdvertencia="\033[1;31m"
ColorArgumentos="\033[1;32m"
FinColor="\033[0m"

CantArgsCorrectos=2
ArgsInsuficientes=65

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo -e "${ColorAdvertencia}Mal uso del script!${FinColor}"
    echo ""
    echo -e 'El uso correcto sería: '$0' '${ColorArgumentos}'[ArchivoDeOrigen] [ImpresoraDestino]'${FinColor}''
    echo ""
    echo "Ejemplo:"
    echo ""
    echo "$0 /root/prueba.txt Officejet7610"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo "Mandando la tarea a la cola de impresión..."
    echo ""
    cat $1 | lp -d $2
    echo ""
fi

