#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para contar la cantidad de archivos que hay en una carpeta
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Archivos-ContarEnCarpeta.sh | bash
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
    echo -e "$0 ${cColorVerde}[CarpetaDondeMirar]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo " $0 /home/usuario"
    
    echo ""
    exit
  else
    ArchivosFind=$(find $1 -type f | wc -l)
    echo "  Contados con find: $ArchivosFind"
    
    echo ""

    # Comprobar si el paquete tree está instalado. Si no lo está, instalarlo.
       if [[ $(dpkg-query -s tree 2>/dev/null | grep installed) == "" ]]; then
         echo ""
         echo "  tree no está instalado. Iniciando su instalación..."         echo ""
         apt-get -y update > /dev/null
         apt-get -y install tree
         echo ""
       fi
    ArchivosTree=$(tree $1 | grep iles | grep , | cut -d',' -f2 | cut -d' ' -f2)
    echo "  Contados con tree: $ArchivosTree"
    echo ""
    
fi

