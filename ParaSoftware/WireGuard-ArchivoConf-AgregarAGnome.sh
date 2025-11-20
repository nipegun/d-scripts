#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar una conexión de wireguard a Gnome usando un archivo .conf
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/WireGuard-ArchivoConf-AgregarAGnome.sh | bash -s [RutaAlArchivoConf]
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/WireGuard-ArchivoConf-AgregarAGnome.sh | sed 's-sudo--g' | bash -s [RutaAlArchivoConf]
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/WireGuard-ArchivoConf-AgregarAGnome.sh | nano -
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
  cCantArgsEsperados=1

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
      echo "    $vNombreDelScript [RutaAlArchivoConf]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '/home/usuariox/Descargas/ConecWireg.conf'"
      echo ""
      exit
  fi

#Definir variables
  vArchivoConf="$1"
  vNomConex=$(basename -s .conf "$vArchivoConf")


# Importar y activar la conexión
  nmcli connection import type wireguard file "$vArchivoConf" || echo "\n  Algo anda mal con el archivo .conf.\n   Puede ser su contenido o su nombre, dado que el nombre del archivo se utilizará como nombre de la interfaz."

# Desactivar el auto-inicio de la conexión
  nmcli connection modify "$vNomConex" connection.autoconnect no

