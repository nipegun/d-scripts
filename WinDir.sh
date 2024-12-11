#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar directorios y archivos de forma similar a como lo hace el dir de Windows
#
#   
#   --all:                     No oculta las entradas que comienzan por .
#   --almost-all:              No muestra las entradas . y .. implícitas
#   --author:                  Usando en conjunto con -l imprime el autor de cada fichero
#   --classify:                Añade un indicador (uno de */=@|) a las entradas
#   --color=always:            Colorea la salida. Puede ser 'always' (por defecto si se omite), 'auto', o 'never'.
#   --context:                 Imprime el contexto de seguridad de cada archivo
#   --format=verbose:          Admite across (-x), commas (-m), horizontal (-x), long (-l), single-column (-1), verbose (-l), vertical (-C)
#   --full-time:               Como -l --time-style=full-iso
#   --group-directories-first: Agrupa directorios antes que los ficheros
#   --human-readable:          Imprime el tamaño de  los archivos en KB, MB y GB
#   --hyperlink=auto:          Crea enlaces a los archivos. Acepta 'always' (por defecto si se omite), 'auto' y 'never'
#   --inode:                   Imprime el número de índice de cada archivo
#   --sort=extension           Admite none (-U), size (-S), time (-t), version (-v), extension (-X)
# ----------

vParam=" --all \
         --almost-all \
         --author \
         --classify \
         --color=always \
         --context \
         --format=verbose \
         --full-time \
         --group-directories-first \
         --human-readable \
         --hyperlink=always \
         --inode \
         --sort=extension "

if [ $# -eq 1 ]
  then
    echo ""
    ls $vParam | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*(2^(8-i)));if(k)printf("%0o ",k); print}' "$1"
    #ls $vParam "$1"
    echo ""
  else
    echo ""
    ls $vParam | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*(2^(8-i)));if(k)printf("%0o ",k); print}'
    #ls $vParam
    echo ""
fi

