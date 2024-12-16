#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para editar la configuración de haproxy
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Soft/HAProxy-Editar.sh | bash
# ----------

echo ""
echo "  Editando el archivo de configuración..."
echo ""
nano /etc/haproxy/haproxy.cfg

echo ""
echo "  Indicando al servicio que vuelva a cargar el archivo de configuración..."
echo ""
service haproxy reload

echo ""
echo "  Estado del servicio:"
echo ""
service haproxy status --no-pager

