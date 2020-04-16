#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------
#  Script de NiPeGun para crear el archivo con los comandos de IPTables
#  que se ejecutarán cada vez que se inicie el sistema
#------------------------------------------------------------------------

echo ""
echo "----------------------------------------------"
echo "  CREANDO EL ARCHIVO PARA METER LOS COMANDOS"
echo "----------------------------------------------"
echo ""
mkdir -p /root/scripts/ 2> /dev/null
echo '#!/bin/bash' > /root/scripts/ComandosIPTables.sh
echo "" >> /root/scripts/ComandosIPTables.sh
echo "#  ESCRIBE ABAJO, UNO POR LÍNEA, LOS COMANDOS DE IPTABLES A EJECUTAR AL ARRANQUE"  >> /root/scripts/ComandosIPTables.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/ComandosIPTables.sh
echo "" >> /root/scripts/ComandosIPTables.sh
chmod 700 /root/scripts/ComandosIPTables.sh
echo "/root/ComandosIPTables" >> /root/scripts/ComandosIPTables.sh

