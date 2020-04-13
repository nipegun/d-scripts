#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar información sobre el/los módulos de memoria RAM
#----------------------------------------------------------------------------------

ColorNotificacion="\033[1;32m"
FinColor="\033[0m"

echo ""
echo -e "${ColorNotificacion}Mostrando información sobre la memoria RAM...${FinColor}"
echo ""
dmidecode --type 17
echo ""

