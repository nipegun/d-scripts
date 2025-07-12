#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para montar la unidad de DVD
#
# Ejecución remota:
#   curl -sL x | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

echo ""
echo "Para ver en que /dev/ está la unidad óptica ejecuta:"
echo "dmesg | grep sr"
echo ""

mkdir -p /Particiones/DVD/ 2> /dev/null
mount -t iso9660 -v /dev/sr0 /Particiones/DVD/

echo ""
echo "Unidad DVD montada en /Particiones/DVD/"
echo ""
