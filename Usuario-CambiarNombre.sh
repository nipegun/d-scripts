#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el nombre de un usuario
#
# Ejecución con curl:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-CambiarNombre.sh | bash -s UsuarioViejo UsuarioNuevo
# ----------

cCantArgsCorrectos=2

if [ $# -ne $cCantArgsCorrectos ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: cndu [NombreDeUsuarioViejo] [NombreDeUsuarioNuevo]"
    echo ""
    echo "Ejemplo:"
    echo ' cndu pepe jose'
    
    echo ""
    exit
  else
    echo ""
    usermod -l $2 $1
    usermod -d /home/$2 -m $2
    groupmod -n $2 $1
    echo ""
fi

