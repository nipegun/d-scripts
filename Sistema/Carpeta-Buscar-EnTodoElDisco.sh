#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para buscar una carpeta en todo el sistema
# ----------

cCantArgumEsperados=1


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: bcees [NombreDeLaCarpeta]"
    echo ""
    echo "Ejemplo:"
    echo "bcees Perro"
    echo "##################################################"
    echo ""
    exit
  else
    echo ""
    find /bin -type d -name $1
    find /boot -type d -name $1
    find /dev -type d -name $1
    find /etc -type d -name $1
    find /home -type d -name $1
    find /lib -type d -name $1
    find /lib64 -type d -name $1
    find /lost+found -type d -name $1
    find /media -type d -name $1
    find /mnt -type d -name $1
    find /opt -type d -name $1
    find /root -type d -name $1
    find /run -type d -name $1
    find /sbin -type d -name $1
    find /srv -type d -name $1
    find /tmp -type d -name $1
    find /usr -type d -name $1
    find /var -type d -name $1
    echo ""
fi

