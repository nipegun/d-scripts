#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para medir la temperatura del procesador en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Hardware-Procesador-Temperatura-Medir.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Comprobar si el paquete lm-sensors está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s lm-sensors 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}    El paquete lm-sensors no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install lm-sensors
    # Detectar sensores
      sensors-detect
    echo "" 
  fi

# Comprobar si el procesador es AMD o Intel
  vProc=$(lscpu | grep -E "Vendor ID:|ID de fabricante:" | cut -d':' -f2 | sed 's- --g')

# Mostrar una información si el procesador es AMD, otra si es Intel y otra si es cualquier otra arquitectura
  if [[ "$vProc" == "AuthenticAMD" ]]; then
    # watch -n 1 'sensors | grep -e Tctl -e Tccd1 -e Tccd2 -e Tccd3 -e Tccd4 -e Tccd5 -e Tccd6'
    vTemp=$(sensors | grep -e Tctl | cut -d'+' -f2 | cut -d'.' -f1)
    echo $(( $vTemp + 1 ))
  elif [[ "$vProc" == "GenuineIntel" ]]; then
    # watch -n 1 'sensors | grep -e Tctl -e Tccd1 -e Tccd2 -e Tccd3 -e Tccd4 -e Tccd5 -e Tccd6'
    sensors coretemp-isa-0000 | grep "Package id" | cut -d'+' -f2 | cut -d'.' -f1
    echo ""
  else
    sensors | grep CPU
    echo ""
  fi
