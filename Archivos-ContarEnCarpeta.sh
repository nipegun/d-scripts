#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para contar la cantidad de archivos que hay en una carpeta
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Archivos-ContarEnCarpeta.sh | bash
#-------------------------------------------------------------------------------------------------------

CantArgsEsperados=1
ArgsInsuficientes=65

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

if [ $# -ne $CantArgsEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${ColorVerde}[CarpetaDondeMirar]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo " $0 /home/usuario"
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo "  Contandos con find:"
    find $1 -type f | wc -l
    echo ""

    ## Comprobar si el paquete tree está instalado. Si no lo está, instalarlo.
       if [[ $(dpkg-query -s tree 2>/dev/null | grep installed) == "" ]]; then
         echo ""
         echo "  tree no está instalado. Iniciando su instalación..."
         echo ""
         apt-get -y update > /dev/null
         apt-get -y install tree
         echo ""
       fi
    echo " Contados por tree:"
    tree $1 | grep iles | grep , | cut -d',' -f2 | cut -d' ' -f2
    echo ""
    
fi

