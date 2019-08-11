#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para crear el archivo con los comandos de NFTables que se ejecutarán cada vez que se inicie el sistema
#----------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Creando el archivo para meter los comandos...${FinColor}"
echo ""
echo '#!/bin/bash' > /root/scripts/ComandosNFTables.sh
echo "" >> /root/scripts/ComandosNFTables.sh
echo "#  ESCRIBE ABAJO, UNO POR LÍNEA, LOS COMANDOS DE NFTABLES A EJECUTAR AL ARRANQUE"  >> /root/scripts/ComandosNFTables.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/ComandosNFTables.sh
echo "" >> /root/scripts/ComandosNFTables.sh
chmod 700 /root/scripts/ComandosNFTables.sh
echo "/root/scripts/ComandosNFTables.sh" >> /root/scripts/ComandosPostArranque.sh

