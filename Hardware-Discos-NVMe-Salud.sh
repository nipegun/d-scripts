#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para comprobar el estado de salud de los discos duros NVMe
#
# Ejecución remota:
#   curl -sL x | bash
# ----------

# Comprobar si el paquete nvme-cli está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s nvme-cli 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  nvme-cli no está instalado. Iniciando su instalación..."     echo ""
     apt-get -y update
     apt-get -y install nvme-cli
     echo ""
 fi

# Obtener la cantidad de discos NVMe que hay instalados en el sistema
  for vNroDiscoNVMe in {0..100}
    do
      if [[ $(nvme list | grep nvme$vNroDiscoNVMe) != "" ]]; then
        aDiscosTotales[$vNroDiscoNVMe]=$(nvme list | grep nvme$vNroDiscoNVMe)
      fi
    done

# Mostrar la salud de todos los discos detectados
  echo ""
  echo "  Hay ${#aDiscosTotales[@]} discos NVMe instalados en el sistema. Mostrando información de salud:"
  echo ""
  for i in "${aDiscosTotales[@]}"
    do
      echo $i
      vDispActual=$(echo $i | cut -d' ' -f1)
      nvme smart-log "$vDispActual" | grep ercentage
      nvme smart-log "$vDispActual" | grep ritten
      echo ""
    done

