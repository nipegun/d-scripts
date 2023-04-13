#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  ScriptDeNiPeGun para encontrar una cadena específica dentro de los archivos de todo el sistema
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
    echo "&0 Perro"
    echo "##################################################"
    echo ""
    exit $E_BADARGS
  else
    echo ""
    grep -rnw --color -e "$1" /bin
    grep -rnw --color -e "$1" /boot
    grep -rnw --color -e "$1" /dev
    grep -rnw --color -e "$1" /etc
    grep -rnw --color -e "$1" /home
    grep -rnw --color -e "$1" /lib
    grep -rnw --color -e "$1" /lib64
    grep -rnw --color -e "$1" /lost+found
    grep -rnw --color -e "$1" /media
    grep -rnw --color -e "$1" /mnt
    grep -rnw --color -e "$1" /opt
    grep -rnw --color -e "$1" /root
    grep -rnw --color -e "$1" /run
    grep -rnw --color -e "$1" /sbin
    grep -rnw --color -e "$1" /srv
    grep -rnw --color -e "$1" /tmp
    grep -rnw --color -e "$1" /usr
    grep -rnw --color -e "$1" /var
    echo ""
fi

# De esta forma sólo buscará en archivos con extensión .c o .h:
  #grep --include=\*.{c,h} -rnw '/path/to/somewhere/' -e "pattern"

# De esta otra forma se excluirá la búsqueda dentro delos archivos con extensión .o:
  #grep --exclude=\*.o -rnw '/path/to/somewhere/' -e "pattern"

# Es posible excluir una o varias carpetas usando e parámetro "--exclude-dir".
  # Por ejemplo, lo siguiente excluirá las carpetas dir1/, dir2/ y todas las que hagan match con *.dst/:
    # grep --exclude-dir={dir1,dir2,*.dst} -rnw '/path/to/search/' -e "pattern"

