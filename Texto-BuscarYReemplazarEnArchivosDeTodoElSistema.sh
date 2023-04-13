#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para encontrar una cadena específica dentro de archivos de todo el sistema y reemplazarla por otra cadena dada
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Texto-BuscarYReemplazarEnArchivosDeTodoElSistema.sh | bash -s CadenaVieja CadenaNueva
# ----------

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 CadenaVieja CadenaNueva"
    echo ""
    echo "Ejemplo:"
    echo "$0 perro gato"
    echo "##################################################"
    echo ""
    exit $E_BADARGS
  else
    echo ""
    find /bin        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /boot       -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /dev        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /etc        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /home       -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /lib        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /lib64      -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /lost+found -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /media      -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /mnt        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /opt        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /root       -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /run        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /sbin       -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /srv        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /tmp        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /usr        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    find /var        -type f -exec sed -i -e "s|$1|$2|g" {} \;
    echo ""
fi

