#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para mostrar las reglas activas de IPTables
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Red-IPTables-ReglasActivas-Mostrar.sh | bash
# ----------

echo ""
echo "  Tablas NAT"
echo ""
/sbin/iptables -nL -v --line-numbers -t nat

echo ""
echo "  Tablas FILTER"
echo ""
/sbin/iptables -nL -v --line-numbers -t filter

echo ""
echo "  Tablas MANGLE"
echo ""
/sbin/iptables -nL -v --line-numbers -t mangle

echo ""
echo "  Tablas RAW"
echo ""
/sbin/iptables -nL -v --line-numbers -t raw

