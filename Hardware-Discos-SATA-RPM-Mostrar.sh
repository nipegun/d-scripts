#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar la temperatura de los discos duros SATA
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Hardware-Discos-SATA-RPM-Mostrar.sh | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete smartmontools está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s smartmontools 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  El paquete smartmontools no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install smartmontools
    echo ""
  fi

echo ""
echo "  /dev/sda:"
echo ""
smartctl -i /dev/sda | grep otation

echo ""
echo "  /dev/sdb:"
echo ""
smartctl -i /dev/sdb | grep otation

echo ""
echo "  /dev/sdc:"
echo ""
smartctl -i /dev/sdc | grep otation

echo ""
echo "  /dev/sdd:"
echo ""
smartctl -i /dev/sdd | grep otation

echo ""
echo "  /dev/sde:"
echo ""
smartctl -i /dev/sde | grep otation

echo ""
echo "  /dev/sdf:"
echo ""
smartctl -i /dev/sdf | grep otation

echo ""
echo "  /dev/sdg:"
echo ""
smartctl -i /dev/sdg | grep otation

