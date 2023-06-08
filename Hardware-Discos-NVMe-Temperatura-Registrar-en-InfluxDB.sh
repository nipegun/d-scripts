#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para mostrar información sobre el/los procesador/es
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Hardware-Discos-NVMe-Temperatura.sh | bash
# ----------

vHostInflux="x.x.x.x"
vPuertoInflux="8086"

# ---------- No tocar a partir de aquí ----------
vBaseDeDatos="hardware"
vHost=$(cat /etc/hostname)
vFecha=$(date +%s%N)

# Definir variables de color
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

# Comprobar si el paquete nvme-cli está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s nvme-cli 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}    nvme-cli no está instalado. Iniciando su instalación...${vFinColor}"
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

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi

vSensor="procesador"
vTemperatura=$(/root/scripts/d-scripts/Hardware-Procesador-Temperatura-Medir.sh)

# Obtener información
  for i in "${aDiscosTotales[@]}"
    do
      # Obtener el identificador del dispositivo
        vIdDispNVMe=$(echo $i | cut -d' ' -f1)
      # Asignar nombre al sensor
        vSensor=$(echo $vIdDispNVMe | cut -d'/' -f3)
      # Obtener la temperatura
        vTemperatura=$(nvme smart-log "$vIdDispNVMe" | grep temperature | cut -d':' -f2 | cut -d' ' -f2)
      # Registrar
        curl -XPOST http://$vHostInflux:$vPuertoInflux/write?db=$vBaseDeDatos --data-binary "$vHost,sensor=$vSensor temperatura=$vTemperatura $vFecha"
    done

