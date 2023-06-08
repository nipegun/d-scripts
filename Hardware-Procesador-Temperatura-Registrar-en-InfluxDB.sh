#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para registrar la temperatura del procesador en una base de datos InfluxDB
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Hardware-Procesador-Temperatura-Registrar-en-InfluxDB.sh | sed 's-x.x.x.x-192.168.1.99-g' | bash
# ----------

vHostInflux="x.x.x.x"
vPuertoInflux="8086"

# ---------- No tocar a partir de aquí ----------
vBaseDeDatos="hardware"
vHost=$(cat /etc/hostname)
vSensor="procesador"
vTemperatura=$(/root/scripts/d-scripts/Hardware-Procesador-Temperatura-Medir.sh)
vFecha=$(date +%s%N)
# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install curl
    echo ""
  fi
curl -XPOST http://$vHostInflux:$vPuertoInflux/write?db=$vBaseDeDatos --data-binary "$vHost,sensor=$vSensor temperatura=$vTemperatura $vFecha"

