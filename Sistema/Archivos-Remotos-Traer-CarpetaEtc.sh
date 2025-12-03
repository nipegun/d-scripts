#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para traer la carpeta / de un sistema remoto mediante rsync en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Archivos-Remotos-Traer-CarpetaEtc.sh | bash -s [IPRemota] [UsuarioRemoto]
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Archivos-Remotos-Traer-CarpetaEtc.sh | sed 's-sudo--g' | bash -s [IPRemota] [UsuarioRemoto]
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Archivos-Remotos-Traer-CarpetaEtc.sh | nano -
# ----------

vIPRemota="$1"
vUsuario="$2"

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
      echo "    $vNombreDelScript [IPRemota] [UsuarioRemoto]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '10.10.76.111' 'arlina'"
      echo ""
      exit
  fi

# Comprobar si el paquete rsync está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s rsync 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete rsync no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install rsync
    echo ""
  fi

# Traer todas las carpetas de dentro de /etc
  # rsync -avz --progress --exclude=".cache" "$vUsuario"@"$vIPRemota":/etc/ .

# Traer la carpeta /etc entera
  rsync -avz --progress --exclude=".cache" "$vUsuario"@"$vIPRemota":/etc .
