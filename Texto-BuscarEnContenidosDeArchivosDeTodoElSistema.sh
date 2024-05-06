#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para buscar una cadena específica dentro del contenido de los archivos de todo el sistema
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Texto-BuscarEnContenidosDeArchivosDeTodoElSistema.sh | bash -s "Cadena"
# ----------

cCantArgumEsperados=1


if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 Cadena"
    echo ""
    echo "Ejemplo:"
    echo "$0 Perro"
    echo "##################################################"
    echo ""
    exit
  else
    echo ""
    grep -rnw --color -e "$1" /bin        2> /dev/null
    grep -rnw --color -e "$1" /boot       2> /dev/null
    grep -rnw --color -e "$1" /dev        2> /dev/null
    grep -rnw --color -e "$1" /etc        2> /dev/null
    grep -rnw --color -e "$1" /home       2> /dev/null
    grep -rnw --color -e "$1" /lib        2> /dev/null
    grep -rnw --color -e "$1" /lib64      2> /dev/null
    grep -rnw --color -e "$1" /lost+found 2> /dev/null
    grep -rnw --color -e "$1" /media      2> /dev/null
    grep -rnw --color -e "$1" /mnt        2> /dev/null
    grep -rnw --color -e "$1" /opt        2> /dev/null
    grep -rnw --color -e "$1" /root       2> /dev/null
    grep -rnw --color -e "$1" /run        2> /dev/null
    grep -rnw --color -e "$1" /sbin       2> /dev/null
    grep -rnw --color -e "$1" /srv        2> /dev/null
    grep -rnw --color -e "$1" /tmp        2> /dev/null
    grep -rnw --color -e "$1" /usr        2> /dev/null
    grep -rnw --color -e "$1" /var        2> /dev/null
    echo ""
fi

# De esta forma sólo buscará en archivos con extensión .c o .h:
  #grep --include=\*.{c,h} -rnw '/path/to/somewhere/' -e "pattern"

# De esta otra forma se excluirá la búsqueda dentro delos archivos con extensión .o:
  #grep --exclude=\*.o -rnw '/path/to/somewhere/' -e "pattern"

# Es posible excluir una o varias carpetas usando e parámetro "--exclude-dir".
  # Por ejemplo, lo siguiente excluirá las carpetas dir1/, dir2/ y todas las que hagan match con *.dst/:
    # grep --exclude-dir={dir1,dir2,*.dst} -rnw '/path/to/search/' -e "pattern"

