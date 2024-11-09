#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para buscar un archivo en todo el sistema
# ----------

cCantArgumEsperados=1


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: baees [NombreDelArchivo]"
    echo ""
    echo "Ejemplo:"
    echo "baees perro.txt"
    echo "##################################################"
    echo ""
    exit
  else
    echo ""
    find /bin -type f -name $1
    find /boot -type f -name $1
    find /dev -type f -name $1
    find /etc -type f -name $1
    find /home -type f -name $1
    find /lib -type f -name $1
    find /lib64 -type f -name $1
    find /lost+found -type f -name $1
    find /media -type f -name $1
    find /mnt -type f -name $1
    find /opt -type f -name $1
    find /root -type f -name $1
    find /run -type f -name $1
    find /sbin -type f -name $1
    find /srv -type f -name $1
    find /tmp -type f -name $1
    find /usr -type f -name $1
    find /var -type f -name $1
    echo ""
fi


