#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para desmontar el disco de una MV de ProxmoxVE montado en una carpeta indicada del host
#-----------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Desmontando disco RAW asociado al loop0...${FinColor}"
echo ""
umount /dev/mapper/loop0p1
kpartx -d /dev/loop0 
losetup -d /dev/loop0

