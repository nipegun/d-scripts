#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para monitorizar las conexiones xrdp
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/xrdp-Conexiones-Monitorizar.sh | bash
#---------------------------------------------------------------------------------------------------------

touch /var/log/XRDPWatch.log
echo ""
echo "  Loqueando conexiones xrdp..."
echo ""
nohup tail -f /var/log/xrdp.log | grep -E "onnected client"\|"onnection established"\|"ogin success" >> /var/log/XRDPWatch.log &
nohup tail -f /var/log/xrdp-sesman.log | grep "reated session"                                       >> /var/log/XRDPWatch.log &

