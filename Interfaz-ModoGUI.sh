#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para hacer que Debian arranque en modo gráfico
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Interfaz-ModoGUI.sh | bash
# ----------

echo ""
echo "-------------------------"
echo "  REALIZANDO CAMBIOS..."
echo "-------------------------"
echo ""

systemctl set-default -f graphical.target

echo ""
echo "-----------------------------------------------------------------------"
echo "  CAMBIOS REALIZADOS: "
echo "  EN EL PRÓXIMO INICIO DEBIAN ARRANCARÁ EN MODO GRÁFICO MULTI-USUARIO"
echo "-----------------------------------------------------------------------"
echo ""

shutdown -r now

