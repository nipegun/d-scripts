#!/bin/bash

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
