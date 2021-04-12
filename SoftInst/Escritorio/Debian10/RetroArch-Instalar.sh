#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para instalar RetroArch en Debian
#-------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo "--------------------------------------------------"
echo "Iniciando el script de instalación de RetroArch..."
echo "--------------------------------------------------"
echo ""

apt-get update -y
apt-get install retroarch
#sed -i -e 's|user_language = "0"|user_language = "3"|g' /home/nipegun/.config/retroarch/retroarch.cfg
