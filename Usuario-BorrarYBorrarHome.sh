#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar un usuario del sistema
#  borrando también su correspondiente carpeta en /home
# ----------

cCantArgumEsperados=1

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [NombreDeUsuario]"
    echo ""
    echo "Ejemplo:"
    echo "$0 pepe"
    echo "##################################################"
    echo ""
    exit
  else
    echo ""
    echo "Borrando el usuario $1 de la lista de usuarios del sistema..."
    echo ""
    userdel $1

    echo ""
    echo "Borrando la carpeta home del usuario $1..."
    echo ""
    rm -r /home/$1
    echo ""
fi

