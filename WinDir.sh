#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar directorios y archivos de forma similar a como lo hace el dir de Windows
# ----------
vParam=" -lha1FX -C --author --group-directories-first --color=auto --time-style=long-iso"

if [ $# -eq 1 ]
  then
    echo ""
    ls $vParam | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*(2^(8-i)));if(k)printf("%0o ",k); print}' "$1"
    echo ""
  else
    echo ""
    ls $vParam | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*(2^(8-i)));if(k)printf("%0o ",k); print}'
    echo ""
fi

