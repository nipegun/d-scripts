#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar Debian cuando hay un repositorio con firmas caducadas
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Iniciando el script de actualización del sistema opeartivo con firmas caducadas...${vFinColor}"
echo ""

echo ""
echo "    Reparando permisos de la carpeta /tmp/ ..."
echo ""
chmod 1777 /tmp

echo ""
echo "    Intentando actualización..."
echo ""
apt-get -o Acquire::Check-Valid-Until=false update
apt-get -y --allow-downgrades upgrade
apt-get -y --allow-downgrades dist-upgrade
apt-get -y autoremove

