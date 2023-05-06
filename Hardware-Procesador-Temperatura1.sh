#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar información sobre el/los procesador/es
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Hardware-Procesador-Temperatura.sh | bash
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}"
    exit 1
  fi

echo ""
echo -e "${vColorAzulClaro}  Mostrando temperatura del procesador...${vFinColor}"
echo ""

# Comprobar si el paquete lm-sensors está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s lm-sensors 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}    lm-sensors no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install lm-sensors
    sensors-detect
    echo ""
  fi

# Comprobar si el procesador es AMD o Intel
  vProc=$(lscpu | grep "Vendor ID" | cut -d':' -f2 | sed 's- --g')
  if [[ "$vProc" == "AuthenticAMD" ]]; then
    # watch -n 1 'sensors | grep -e Tctl -e Tccd1 -e Tccd2 -e Tccd3 -e Tccd4 -e Tccd5 -e Tccd6'
    sensors | grep -e Tctl -e Tccd1 -e Tccd2 -e Tccd3 -e Tccd4 -e Tccd5 -e Tccd6
  elif [[ "$vProc" == "GenuineIntel" ]]; then
    # watch -n 1 'sensors | grep -e Tctl -e Tccd1 -e Tccd2 -e Tccd3 -e Tccd4 -e Tccd5 -e Tccd6'
    sensors | grep CPU
  fi

