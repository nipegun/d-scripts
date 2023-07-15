#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ------------
#  SCRIPT DE NIPEGUN PARA BORRAR TAGs DE ARCHIVOS MP3 DE UNA CARPETA
#  X Y TAMBIÉN DE SUS SUB-CARPETAS DE FORMA RECURSIVA
# ----------

EXPECTED_ARGS=1


if [ $# -ne $EXPECTED_ARGS ]
  then
    echo ""
    echo "##################################################"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 ruta"
    echo ""
    echo "Ejemplo:"
    echo "&0 /etc/"
    echo "##################################################"
    echo ""
    exit $E_BADARGS
  else
    ## Comprobar si el paquete eyed3 está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s eyed3 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  eyed3 no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update > /dev/null
        apt-get -y install eyed3
        echo ""
      fi
    echo ""
    eyeD3 --remove-all $1
    echo ""
fi

