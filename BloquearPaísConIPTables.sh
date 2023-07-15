#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para bloquear países con IPTables
#
#  https://www.ip2location.com/free/visitor-blocker
# ----------

VarPaises="AK,AR"
VarCarpetaDeTrabajo="/tmp"
#######################################
cd $VarCarpeta
wget -c --output-document=iptables-blocklist.txt http://blogama.org/country_query.php?country=$VarPaises
if [ -f iptables-blocklist.txt ]; then
  VarBaseDeDatosABloquear="iptables-blocklist.txt"
  VarIPs=$(grep -Ev "^#" $VarBaseDeDatosABloquear)
  for i in $VarIPs
  do
    iptables -A INPUT -s $i -j DROP
    iptables -A OUTPUT -d $i -j DROP
  done
fi
rm $VarCarpetaDeTrabajo/iptables-blocklist.txt

