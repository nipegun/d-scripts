#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------
#  Script de NiPeGun para actualizar Debian cuando hay un repositorio con firmas caducadas
#-------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo -e "${ColorVerde}Reparando permisos de la carpeta /tmp/ ...${FinColor}"
echo ""
chmod 1777 /tmp

echo ""
echo -e "${ColorVerde}Actualizando sistema operativo con repo caducado...${FinColor}"
echo ""
apt-get -o Acquire::Check-Valid-Until=false update
apt-get -y --allow-downgrades upgrade
apt-get -y --allow-downgrades dist-upgrade
apt-get -y autoremove

