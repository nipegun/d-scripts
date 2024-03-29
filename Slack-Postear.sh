#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para postear en Slack desde Debian
#
# Ejecución remota:
#   curl -sL x | bash
# ----------

vSlackHost=PUT_YOUR_HOST_HERE

# ---

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

vToken=$1

if [[ $vToken == "" ]]
then
  echo "No se ha indicado un token"
  exit 1
fi

shift

vCanal=$1

if [[ $vCanal == "" ]]
then
  echo "No se ha indicado un canal"
  exit 1
fi

shift

vTexto=$*

if [[ $vTexto == "" ]]
then
  echo "No se ha indicado el texto a postear"
  exit 1
fi

vTextoEscapado=$(echo $vTexto | sed 's/"/\"/g' | sed "s/'/\'/g" )
vJson="{\"channel\": \"#$vCanal\", \"text\": \"$vTextoEscapado\"}"

# Postear el mensaje
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install curl
      echo ""
    fi
  curl -sL -d "payload=$vJson" "https://$vSlackHost.slack.com/services/hooks/incoming-webhook?token=$vToken"

