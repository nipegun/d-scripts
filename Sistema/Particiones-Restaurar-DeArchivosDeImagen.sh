#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para restaurar a disco, particiones guardadas en archivos de imagen
#
# Ejecución remota con argumentos (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Restaurar-DeArchivosDeImagen.sh | bash -s [Argumento1] [Argumento2] [Argumento3]
#
# Ejecución remota con argumentos como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Restaurar-DeArchivosDeImagen.sh | sed 's-sudo--g' | bash -s [Argumento1] [Argumento2] [Argumento3]
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Particiones-Restaurar-DeArchivosDeImagen.sh | nano -
# ----------

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
      echo "    $vNombreDelScript [RutaAlDeviceDeLaUnidad] [CantDeParticiones]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript /dev/nvme0n1 2"
      echo ""
      exit
  fi

