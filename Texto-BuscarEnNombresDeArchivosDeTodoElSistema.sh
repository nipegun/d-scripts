#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para encontrar una cadena específica dentro de archivos de todo el sistema
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Texto-BuscarEnNombresDeArchivosDeTodoElSistema.sh | bash -s texto
# ----------

EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 texto"
    echo ""
    echo "Ejemplo:"
    echo "$0 perro"
    echo "##################################################"
    echo ""
    exit $E_BADARGS
  else
    echo ""
    find /bin        -type f -name "*$2*" -print
    find /boot       -type f -name "*$2*" -print
    find /dev        -type f -name "*$2*" -print
    find /etc        -type f -name "*$2*" -print
    find /home       -type f -name "*$2*" -print
    find /lib        -type f -name "*$2*" -print
    find /lib64      -type f -name "*$2*" -print
    find /lost+found -type f -name "*$2*" -print
    find /media      -type f -name "*$2*" -print
    find /mnt        -type f -name "*$2*" -print
    find /opt        -type f -name "*$2*" -print
    find /root       -type f -name "*$2*" -print
    find /run        -type f -name "*$2*" -print
    find /sbin       -type f -name "*$2*" -print
    find /srv        -type f -name "*$2*" -print
    find /tmp        -type f -name "*$2*" -print
    find /usr        -type f -name "*$2*" -print
    find /var        -type f -name "*$2*" -print
    echo ""
    echo ""
    #find /bin        -type f -exec grep --color=auto "$1" {} \;
    #find /boot       -type f -exec grep --color=auto "$1" {} \;
    #find /dev        -type f -exec grep --color=auto "$1" {} \;
    #find /etc        -type f -exec grep --color=auto "$1" {} \;
    #find /home       -type f -exec grep --color=auto "$1" {} \;
    #find /lib        -type f -exec grep --color=auto "$1" {} \;
    #find /lib64      -type f -exec grep --color=auto "$1" {} \;
    #find /lost+found -type f -exec grep --color=auto "$1" {} \;
    #find /media      -type f -exec grep --color=auto "$1" {} \;
    #find /mnt        -type f -exec grep --color=auto "$1" {} \;
    #find /opt        -type f -exec grep --color=auto "$1" {} \;
    #find /root       -type f -exec grep --color=auto "$1" {} \;
    #find /run        -type f -exec grep --color=auto "$1" {} \;
    #find /sbin       -type f -exec grep --color=auto "$1" {} \;
    #find /srv        -type f -exec grep --color=auto "$1" {} \;
    #find /tmp        -type f -exec grep --color=auto "$1" {} \;
    #find /usr        -type f -exec grep --color=auto "$1" {} \;
    #find /var        -type f -exec grep --color=auto "$1" {} \;
    echo ""
fi

