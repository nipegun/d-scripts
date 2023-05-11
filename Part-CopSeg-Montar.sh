#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para montar la partición donde se van a ejecutar las copias de seguridad
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Part-CopSeg-Montar.sh | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

echo ""
echo -e "${vColorAzulClaro}  Montando la partición de copias de seguridad...${vFinColor}"
echo ""
mkdir -p /Particiones/CopSeg 2> /dev/null
mount -t auto -v /dev/disk/by-partlabel/PartCopSeg /Particiones/CopSeg

echo ""
echo "    Indicando que el disco que tiene la partición de copia de seguridad se apague después de 5 min. sin usar..."
echo ""
hdparm -S 60 /dev/disk/by-partlabel/PartCopSeg

