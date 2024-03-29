#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar información sobre el/los módulos de memoria RAM
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Mostrando información sobre la memoria RAM...${cFinColor}"
echo ""

echo ""
echo -e "${cColorVerde}    Ejecutando: dmidecode --type 17...${cFinColor}"
echo ""
# Comprobar si el paquete lshw está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s lshw 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}      lshw no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install lshw
    echo ""
  fi
dmidecode --type 17
echo ""


echo ""
echo -e "${cColorVerde}    Ejecutando: lshw -class memory...${cFinColor}"
echo ""
lshw -class memory
echo ""


echo ""
echo -e "${cColorVerde}    Ejecutando: decode-dimms...${cFinColor}"
echo ""
# Comprobar si el paquete i2c-tools está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s i2c-tools 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}      i2c-tools no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install i2c-tools
    echo ""
  fi
modprobe eeprom
decode-dimms
echo ""

