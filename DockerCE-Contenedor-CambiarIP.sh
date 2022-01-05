#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------
#  Script de NiPeGun para cambiar la IP de un container de Docker
#------------------------------------------------------------------

NombreContenedor="portainer"
NuevaIP="172.17.0.1"

## Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  jq no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update > /dev/null
     apt-get -y install jq
     echo ""
   fi
Red=$(docker inspect $NombreContenedor -f "{{json .NetworkSettings.Networks }}" | jq .bridge.NetworkID | cut -d'"' -f2)

#docker network ls
docker network disconnect $Red $NombreContenedor
docker network connect --ip $NuevaIP $Red $NombreContenedor
