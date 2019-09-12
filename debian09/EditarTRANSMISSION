#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA EDITAR LA CONFIGURACIÓN DE TRANSMISSION
#------------------------------------------------------------------

echo ""
echo "-------------------------------------------------"
echo "  DETENIENDO EL SERVICIO TRANSMISSION-DAEMON..."
echo "-------------------------------------------------"
echo ""
service transmission-daemon stop

echo ""
echo "-------------------------------------------"
echo "  EDITANDO EL ARCHIVO DE CONFIGURACIÓN..."
echo "-------------------------------------------"
echo ""
nano /etc/transmission-daemon/settings.json

echo ""
echo "-------------------------------------------------"
echo "  ARRANCANDO EL SERVICIO TRANSMISSION-DAEMON..."
echo "-------------------------------------------------"
echo ""
service transmission-daemon start

