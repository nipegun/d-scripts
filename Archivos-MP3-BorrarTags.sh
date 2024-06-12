#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar tags de archivos mp3 en una carpeta dada (Y subcarpetas)
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Archivos-MP3-BorrarTags.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/Archivos-MP3-BorrarTags.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Archivos-MP3-BorrarTags.sh | bash -s Parámetro1 Parámetro2
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir cantidad de argumentos esperados
  cCantArgumEsperados=1


if [ $# -ne $cCantArgumEsperados ]
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
    exit
  else
    # Comprobar si el paquete eyed3 está instalado. Si no lo está, instalarlo.
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

