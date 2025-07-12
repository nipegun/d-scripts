#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer cambios en la configuración de transmission-daemon
# ----------

echo ""
echo "  DETENIENDO EL SERVICIO TRANSMISSION-DAEMON..."echo ""
service transmission-daemon stop

echo ""
echo "  EDITANDO EL ARCHIVO DE CONFIGURACIÓN..."echo ""
nano /etc/transmission-daemon/settings.json

echo ""
echo "  ARRANCANDO EL SERVICIO TRANSMISSION-DAEMON..."echo ""
service transmission-daemon start

