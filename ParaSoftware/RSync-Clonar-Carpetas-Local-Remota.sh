#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para clonar una carpeta local hacia una carpeta remota con RSync en Debian
#
# Ejecución:
#   ./RSync-ClonarCarpetas.sh '/Carpeta/De/Origen/' 'root@10.20.30.40:/Carpeta/Remota/'
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-Clonar-Carpetas-Local-Remota.sh | bash -s --  '/Carpeta/De/Origen/' 'root@10.20.30.40:/Carpeta/Remota/'
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-Clonar-Carpetas-Local-Remota.sh | sed 's-sudo--g' | bash -s --  '/Carpeta/De/Origen/' 'root@10.20.30.40:/Carpeta/Remota/'
#
# Bajar y editar directamente el archivo en nano:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/RSync-Clonar-Carpetas-Local-Remota.sh | nano -
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
      echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería:${cFinColor}"
      echo ""
      if [[ "$0" == "bash" ]]; then
        vNombreDelScript="script.sh"
      else
        vNombreDelScript="$0"
      fi
      echo "    $vNombreDelScript [CarpetaLocalOrigen/] [Usuario@Host:/CarpetaRemotaDestino/]"
      echo ""
      echo "  Ejemplo:"
      echo ""
      echo "    $vNombreDelScript '/mnt/PartDatos/' 'root@10.10.10.20:/mnt/BackupDatos/'"
      echo ""
      exit 1
  fi

vCarpetaLocalOrigen="$1"   # La / final es mandatoria
vCarpetaRemotaDestino="$2" # La / final es mandatoria. Formato: usuario@servidor:/ruta/remota/

# Comprobar que la carpeta local de origen termine en /
  if [[ "$vCarpetaLocalOrigen" != */ ]]
    then
      echo ""
      echo -e "${cColorRojo}  La carpeta local de origen debe terminar con /.${cFinColor}"
      echo ""
      echo "    Origen recibido: $vCarpetaLocalOrigen"
      echo ""
      exit 1
  fi

# Comprobar que la carpeta remota de destino termine en /
  if [[ "$vCarpetaRemotaDestino" != */ ]]
    then
      echo ""
      echo -e "${cColorRojo}  La carpeta remota de destino debe terminar con /.${cFinColor}"
      echo ""
      echo "    Destino recibido: $vCarpetaRemotaDestino"
      echo ""
      exit 1
  fi

# Comprobar que la carpeta local de origen exista
  if [ ! -d "$vCarpetaLocalOrigen" ]
    then
      echo ""
      echo -e "${cColorRojo}  La carpeta local de origen no existe.${cFinColor}"
      echo ""
      echo "    Origen recibido: $vCarpetaLocalOrigen"
      echo ""
      exit 1
  fi

# Comprobar que el destino tenga formato remoto usuario@servidor:/ruta/
  if [[ "$vCarpetaRemotaDestino" != *@*:/* ]]
    then
      echo ""
      echo -e "${cColorRojo}  El destino debe tener formato remoto.${cFinColor}"
      echo ""
      echo "  Formato esperado:"
      echo ""
      echo "    usuario@servidor:/ruta/remota/"
      echo ""
      echo "  Destino recibido:"
      echo ""
      echo "    $vCarpetaRemotaDestino"
      echo ""
      exit 1
  fi

echo ""
echo "  Intentando clonación con RSync hacia destino remoto..."
echo ""
echo "    Origen local:    $vCarpetaLocalOrigen"
echo "    Destino remoto:  $vCarpetaRemotaDestino"
echo ""

sudo rsync -aAHv --numeric-ids --info=progress2 -e ssh \
  "$vCarpetaLocalOrigen" "$vCarpetaRemotaDestino"
