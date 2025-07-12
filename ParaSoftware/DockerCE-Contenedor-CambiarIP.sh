#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar la IP de un container de Docker
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/DockerCE-Contenedor-CambiarIP.sh | bash
# ----------

NombreContenedor="portainer"
NuevaIP="172.17.0.10" # No puede ser 172.17.0.1, porque esa es la IP de la interfaz de Docker. Tiene que ser a partir de la 172.17.0.2

# Comprobar si el contenedor está corriendo. Si no lo está, abortar.
  if [[ $(docker ps 2>/dev/null | grep $NombreContenedor) == "" ]]; then
    echo ""
    echo "  El contenedor $NombreContenedor no se está ejecutando."
    echo "  No se puede cambiar la IP de un contenedor que no se está ejecutando."
    echo ""
  else
    # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  jq no está instalado. Iniciando su instalación..."        echo ""
        apt-get -y update > /dev/null
        apt-get -y install jq
        echo ""
      fi
    Red=$(docker inspect $NombreContenedor -f "{{json .NetworkSettings.Networks }}" | jq .bridge.NetworkID | cut -d'"' -f2)
    # Comprobar que la red no sea null, si es null, abortar.
      if [[ $Red == "null" ]]; then
        echo ""
        echo "  La red es $Red, abortando..."        echo ""
      else
        echo ""
        echo " El contenedor $NombreContenedor está conectado a la red $Red"
        echo ""
        #docker network ls
        docker network disconnect $Red $NombreContenedor
        docker network connect --ip $NuevaIP $Red $NombreContenedor
        echo ""
      fi
   fi

