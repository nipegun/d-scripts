#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un pool de criptomonedas en Debian10
#-------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo ""
echo -e "${ColorVerde}---------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}Iniciando el script de instalación del pool de criptominería...${FinColor}"
echo -e "${ColorVerde}---------------------------------------------------------------${FinColor}"
echo ""
echo ""

## Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "curl no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install curl
fi

## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "dialog no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install dialog
fi

curl https://raw.githubusercontent.com/cryptopool-builders/Multi-Pool-Installer/master/bootstrap.sh | bash

