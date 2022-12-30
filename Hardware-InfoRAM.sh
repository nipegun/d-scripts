#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------
#  Script de NiPeGun para mostrar información sobre el/los módulos de memoria RAM
#----------------------------------------------------------------------------------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Mostrando información sobre la memoria RAM...${vFinColor}"
echo ""

# Comprobar si el paquete lshw está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s lshw 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  lshw no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update && apt-get -y install lshw
    echo ""
  fi

dmidecode --type 17
echo ""

