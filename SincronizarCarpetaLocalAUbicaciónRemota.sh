#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para SINCRONIZAR UNA CARPETA LOCAL
#  HACIA UNA CARPETA REMOTA MEDIANTE SSH
# ----------

cCantArgumEsperados=4


if [ $# -ne $EXPECTED_ARGS ]

  then

    echo ""
    echo "---------------------------------------------------------------------------------------------------------"
    echo "  Mal uso del script."
    echo ""
    echo "  El uso correcto sería:"
    echo "  $0 CarpetaLocal UsuarioRemoto IPRemota CarpetaRemota"
    echo ""
    echo "  Ejemplo:"
    echo "  $0 /home/pepe/descargas zordor 44.15.214.21 ~/descargas/externas"
    echo "---------------------------------------------------------------------------------------------------------"
    echo ""
    exit

  else

    echo ""
    echo "--------------------"
    echo "  SINCRONIZANDO..."    echo "--------------------"
    echo ""
    #echo -e "password" | rsync -a --delete /root/scripts/ yo@192.168.1.125:~/scripts
    rsync -a --delete $1 $2@$3:$4

    echo ""
    
    echo "  EJECUCIÓN DEL SCRIPT FINALIZADA"
    
    echo ""
    
fi

