#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para clonar un linux con RSync en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-ClonarCarpetas.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-ClonarCarpetas.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-ClonarCarpetas.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantArgsEsperados=2

# Comprobar que se hayan pasado la cantidad de argumentos esperados. Abortar el script si no.
  if [ $# -ne $cCantArgsEsperados ]
    then
      echo ""
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="script.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "    $vNombreDelScript [Argumento1] [Argumento2]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '10.10.76.111' 'arlina'"
      echo ""
      exit 1
  fi

vCarpetaLinuxOrigen="$1"  # La / final es mandatoria
vCarpetaLinuxDestino="$2" # La / final es mandatoria

# Comprobar que las dos carpetas terminen en /
if [[ "$vCarpetaLinuxOrigen" != */ ]]
  then
    echo ""
    echo -e "${cColorRojo}  La carpeta de origen debe terminar con /.${cFinColor}"
    echo ""
    echo "    Origen recibido: $vCarpetaLinuxOrigen"
    echo ""
    exit 1
fi

if [[ "$vCarpetaLinuxDestino" != */ ]]
  then
    echo ""
    echo -e "${cColorRojo}  La carpeta de destino debe terminar con /.${cFinColor}"
    echo ""
    echo "    Destino recibido: $vCarpetaLinuxDestino"
    echo ""
    exit 1
fi

echo ""
echo "  Intentando clonación con RSync..."
echo "    Origen: $vCarpetaLinuxOrigen"
echo "    Destino: $vCarpetaLinuxDestino"
echo ""

#sudo nice -n 19 ionice -c3 rsync -aAXHv --numeric-ids --info=progress2 --bwlimit=10M \
#sudo rsync -aAXHv --numeric-ids --info=progress2 --bwlimit=40M \
sudo rsync -aAXHv --numeric-ids --info=progress2 \
  "$vCarpetaLinuxOrigen" "$vCarpetaLinuxDestino"
