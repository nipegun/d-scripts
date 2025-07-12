#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar Debian cuando hay un repositorio con firmas caducadas
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Iniciando el script de actualización del sistema opeartivo con firmas caducadas...${cFinColor}"
echo ""

echo ""
echo "    Reparando permisos de la carpeta /tmp/ ..."
echo ""
chmod 1777 /tmp

echo ""
echo "    Intentando actualización..."
echo ""
apt-get -o Acquire::Check-Valid-Until=false update
apt-get -y --allow-downgrades dist-upgrade
apt-get -y autoremove
apt-get -y autoclean
