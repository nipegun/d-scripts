#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar información sobre el/los procesador/es
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Hardware-Discos-NVMe-Temperatura-Mostrar.sh | bash
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
    exit 1
  fi

# Comprobar si el paquete nvme-cli está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s nvme-cli 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}    nvme-cli no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install nvme-cli
    #sensors-detect
    echo ""
  fi

# Obtener la cantidad de discos NVMe que hay instalados en el sistema
  for vNroDiscoNVMe in {0..100}
    do
      if [[ $(nvme list | grep nvme$vNroDiscoNVMe) != "" ]]; then
        aDiscosTotales[$vNroDiscoNVMe]=$(nvme list | grep nvme$vNroDiscoNVMe)
      fi
    done

# Mostrar la temperatura de todos los discos detectados
  echo ""
  echo "  Hay ${#aDiscosTotales[@]} discos NVMe instalados en el sistema. Mostrando información de temperatura:"
  echo ""
  for i in "${aDiscosTotales[@]}"
    do
      echo $i
      vDispActual=$(echo $i | cut -d' ' -f1)
      nvme smart-log "$vDispActual" | grep temperature
      echo ""
    done

